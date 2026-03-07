import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Drop-in replacement for [AvatarCharacter] that renders an image asset
/// when available, falling back to the [CharacterPainter] CustomPaint.
///
/// Image assets are expected at:
///   `assets/images/characters/{name}/{name}_{trackId}_{stage}.png`
///   `assets/images/characters/{name}/{name}_base.png`
class AvatarImage extends StatefulWidget {
  final int characterIndex;
  final double size;
  final int colorIndex;
  final String? hat;
  final int level;
  final Map<String, int>? trackProgress;

  static const int characterCount = 6;

  static const List<String> characterNames = [
    'mage',
    'fairy',
    'merperson',
    'superhero',
    'alien',
    'robot',
  ];

  static const List<Color> _backgroundColors = [
    Color(0xFFE8D5FF),
    Color(0xFFFFD5E5),
    Color(0xFFD5F5FF),
    Color(0xFFD5FFE0),
    Color(0xFFFFF5D5),
    Color(0xFFFFD5D5),
  ];

  static const List<Color> _borderColors = [
    Color(0xFF9B59B6),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFFF44336),
  ];

  /// Track display priority: aura is most visible, then headwear, then accessory.
  static const List<String> _trackPriority = ['aura', 'headwear', 'accessory'];

  const AvatarImage({
    super.key,
    required this.characterIndex,
    this.size = 80,
    this.colorIndex = 0,
    this.hat,
    this.level = 1,
    this.trackProgress,
  });

  /// Returns the best asset path for the character's current track progress.
  /// Picks the track with the highest stage; ties broken by [_trackPriority].
  /// Falls back to base image if no track progress.
  static String assetPath(int characterIndex, Map<String, int>? trackProgress) {
    final name = characterNames[characterIndex % characterNames.length];
    final dir = 'assets/images/characters/$name';

    if (trackProgress != null && trackProgress.isNotEmpty) {
      String? bestTrack;
      int bestStage = 0;
      int bestPriority = _trackPriority.length;

      for (final entry in trackProgress.entries) {
        if (entry.value <= 0) continue;
        final priority = _trackPriority.indexOf(entry.key);
        final effectivePriority = priority >= 0 ? priority : _trackPriority.length;
        if (entry.value > bestStage ||
            (entry.value == bestStage && effectivePriority < bestPriority)) {
          bestTrack = entry.key;
          bestStage = entry.value;
          bestPriority = effectivePriority;
        }
      }

      if (bestTrack != null) {
        return '$dir/${name}_${bestTrack}_$bestStage.png';
      }
    }

    return '$dir/${name}_base.png';
  }

  /// Returns the asset path for a specific track and stage (for picker previews).
  static String trackAssetPath(int characterIndex, String trackId, int stage) {
    final name = characterNames[characterIndex % characterNames.length];
    return 'assets/images/characters/$name/${name}_${trackId}_$stage.png';
  }

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  Uint8List? _imageBytes;
  bool _checked = false;
  late String _assetPath;

  @override
  void initState() {
    super.initState();
    _assetPath = AvatarImage.assetPath(widget.characterIndex, widget.trackProgress);
    _loadImage();
  }

  @override
  void didUpdateWidget(AvatarImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPath = AvatarImage.assetPath(widget.characterIndex, widget.trackProgress);
    if (newPath != _assetPath) {
      _assetPath = newPath;
      _imageBytes = null;
      _checked = false;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    try {
      final data = await rootBundle.load(_assetPath);
      if (mounted) {
        setState(() {
          _imageBytes = data.buffer.asUint8List();
          _checked = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _checked = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        AvatarImage._borderColors[widget.characterIndex % AvatarImage._borderColors.length];
    final bgColor =
        AvatarImage._backgroundColors[widget.colorIndex % AvatarImage._backgroundColors.length];

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: _imageBytes != null
              ? _buildImageContent()
              : _buildPainterFallback(),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return Padding(
      padding: EdgeInsets.only(top: widget.size * 0.05),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          // Show roughly the top 60% of the character (head + torso)
          height: 220,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 220 / 360,
              child: Image.memory(
                _imageBytes!,
                width: 200,
                height: 360,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('AvatarImage error: $error for $_assetPath');
                  return _buildPainterFallback();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPainterFallback() {
    return const SizedBox.shrink();
  }
}
