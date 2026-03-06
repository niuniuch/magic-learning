import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:magic_learning/features/avatar/painters/character_painter.dart';
import 'package:magic_learning/features/avatar/widgets/avatar_image.dart';

/// Full-body character widget that tries to render an image asset and falls
/// back to the [CharacterPainter] CustomPaint when no image is available.
///
/// This is designed for the upgrade screen (200x340), view screen (220x380),
/// and similar full-body display contexts. Unlike [AvatarImage], this widget
/// does NOT apply circle clipping — it renders the full character at the
/// given width/height.
class AvatarFullBody extends StatefulWidget {
  final int characterIndex;
  final double width;
  final double height;
  final int level;
  final Map<String, int>? trackProgress;

  const AvatarFullBody({
    super.key,
    required this.characterIndex,
    this.width = 200,
    this.height = 340,
    this.level = 1,
    this.trackProgress,
  });

  @override
  State<AvatarFullBody> createState() => _AvatarFullBodyState();
}

class _AvatarFullBodyState extends State<AvatarFullBody> {
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
  void didUpdateWidget(AvatarFullBody oldWidget) {
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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _imageBytes != null
          ? Image.memory(
              _imageBytes!,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('AvatarFullBody image error: $error for $_assetPath');
                return _buildPainter();
              },
            )
          : _buildPainter(),
    );
  }

  Widget _buildPainter() {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: CharacterPainter(
        characterIndex: widget.characterIndex,
        level: widget.level,
        trackProgress: widget.trackProgress,
      ),
    );
  }
}
