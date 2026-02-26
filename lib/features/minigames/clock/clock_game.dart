import 'dart:math';

class ClockQuestion {
  final String questionText;
  final String correctAnswer;
  final List<String> choices;
  final List<int> clockHours; // 1-12 values for clock face display

  const ClockQuestion({
    required this.questionText,
    required this.correctAnswer,
    required this.choices,
    required this.clockHours,
  });
}

class ClockGame {
  final String modeId;
  final Random _random = Random();

  ClockGame({required this.modeId});

  ClockQuestion generateQuestion() {
    switch (modeId) {
      case 'clock_ampm':
        return _generateAmPm();
      case 'clock_elapsed':
        return _generateElapsed();
      case 'clock_future':
        return _generateFuture();
      default:
        return _generateAmPm();
    }
  }

  // ===== AM/PM mode =====
  ClockQuestion _generateAmPm() {
    // Only hours where 24h ≠ 12h display
    final pool = [0, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
    final h24 = pool[_random.nextInt(pool.length)];
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    final period = polishPeriod(h24);

    String displayTime;
    if (h24 == 0) {
      displayTime = '12:00 — północ';
    } else {
      displayTime = '$h12:00 $period';
    }

    final questionText = 'Zegar pokazuje $displayTime.\nKtóra to godzina w zapisie 24h?';
    final correct = _fmtH(h24);

    final wrongs = <String>{};
    // Opposite half of day
    wrongs.add(_fmtH((h24 + 12) % 24));
    // The 12h value itself
    if (_fmtH(h12) != correct) wrongs.add(_fmtH(h12));
    // Nearby hours
    var attempts = 0;
    while (wrongs.length < 3 && attempts < 30) {
      attempts++;
      var w = h24 + _random.nextInt(7) - 3;
      if (w < 0) w += 24;
      if (w > 23) w -= 24;
      if (_fmtH(w) != correct) wrongs.add(_fmtH(w));
    }
    while (wrongs.length < 3) {
      wrongs.add(_fmtH(pool[_random.nextInt(pool.length)]));
    }

    final wrongList = wrongs.where((w) => w != correct).take(3).toList();
    final allChoices = [correct, ...wrongList]..shuffle(_random);

    return ClockQuestion(
      questionText: questionText,
      correctAnswer: correct,
      choices: allChoices,
      clockHours: [h12],
    );
  }

  // ===== Elapsed time mode =====
  ClockQuestion _generateElapsed() {
    final h24start = _random.nextInt(24);
    final diff = 1 + _random.nextInt(8);
    final h24end = (h24start + diff) % 24;
    final crossesMidnight = h24end < h24start;

    final clock1 = h24start % 12 == 0 ? 12 : h24start % 12;
    final clock2 = h24end % 12 == 0 ? 12 : h24end % 12;

    final desc1 = _describeH(h24start);
    final desc2 = _describeH(h24end);
    final nextDay = crossesMidnight ? ' (następnego dnia)' : '';

    final questionText = 'Ile pełnych godzin minęło\nod $desc1\ndo $desc2$nextDay?';
    final correct = '$diff godz.';

    final wrongs = <String>{};
    final reverseDiff = 12 - (diff % 12);
    if (reverseDiff != diff && reverseDiff > 0) {
      wrongs.add('$reverseDiff godz.');
    }
    var attempts = 0;
    while (wrongs.length < 3 && attempts < 30) {
      attempts++;
      var w = diff + _random.nextInt(7) - 3;
      if (w <= 0) w = diff + 1 + _random.nextInt(4);
      if (w != diff && w > 0 && w <= 12) wrongs.add('$w godz.');
    }
    while (wrongs.length < 3) {
      wrongs.add('${1 + _random.nextInt(11)} godz.');
    }

    final wrongList = wrongs.where((w) => w != correct).take(3).toList();
    final allChoices = [correct, ...wrongList]..shuffle(_random);

    return ClockQuestion(
      questionText: questionText,
      correctAnswer: correct,
      choices: allChoices,
      clockHours: [clock1, clock2],
    );
  }

  // ===== Future time mode =====
  ClockQuestion _generateFuture() {
    final h24start = _random.nextInt(24);
    final addH = 1 + _random.nextInt(8);
    final h24end = (h24start + addH) % 24;
    final crossesMidnight = h24end < h24start;

    final clock1 = h24start % 12 == 0 ? 12 : h24start % 12;

    final desc1 = _describeH(h24start);
    final desc2 = _describeH(h24end);
    final nextDay = crossesMidnight ? ' (następnego dnia)' : '';

    final questionText = 'Zegar pokazuje $desc1.\nKtóra godzina będzie za $addH godz.$nextDay?';
    final correct = desc2;

    final wrongs = <String>{};
    // Common mistake: subtract instead of add
    final subH24 = ((h24start - addH) % 24 + 24) % 24;
    final subDesc = _describeH(subH24);
    if (subDesc != correct) wrongs.add(subDesc);
    // Nearby hours
    var attempts = 0;
    while (wrongs.length < 3 && attempts < 40) {
      attempts++;
      var w = h24end + _random.nextInt(7) - 3;
      w = ((w % 24) + 24) % 24;
      final d = _describeH(w);
      if (d != correct) wrongs.add(d);
    }
    while (wrongs.length < 3) {
      wrongs.add(_describeH(_random.nextInt(24)));
    }

    final wrongList = wrongs.where((w) => w != correct).take(3).toList();
    final allChoices = [correct, ...wrongList]..shuffle(_random);

    return ClockQuestion(
      questionText: questionText,
      correctAnswer: correct,
      choices: allChoices,
      clockHours: [clock1],
    );
  }

  // ===== Helpers =====
  String _fmtH(int h24) => '${h24 == 0 ? 24 : h24}:00';

  String _describeH(int h24) {
    if (h24 == 0) return '12:00 — północ';
    if (h24 == 12) return '12:00 — południe';
    final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
    return '$h12:00 ${polishPeriod(h24)}';
  }

  static String polishPeriod(int h24) {
    if (h24 == 0) return 'północ';
    if (h24 >= 1 && h24 <= 4) return 'w nocy';
    if (h24 >= 5 && h24 <= 9) return 'rano';
    if (h24 >= 10 && h24 <= 11) return 'przed południem';
    if (h24 == 12) return 'południe';
    if (h24 >= 13 && h24 <= 17) return 'po południu';
    if (h24 >= 18 && h24 <= 22) return 'wieczorem';
    if (h24 == 23) return 'w nocy';
    return '';
  }
}
