// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Magiczne Uczenie';

  @override
  String get createAvatar => 'Stwórz swoją postać';

  @override
  String get chooseCharacter => 'Wybierz postać';

  @override
  String get enterName => 'Wpisz imię';

  @override
  String get namePlaceholder => 'Twoje imię...';

  @override
  String get start => 'Start!';

  @override
  String get level => 'Poziom';

  @override
  String get stars => 'Gwiazdki';

  @override
  String get miniGameHub => 'Wybierz grę';

  @override
  String get addition => 'Dodawanie';

  @override
  String get subtraction => 'Odejmowanie';

  @override
  String get multiplication => 'Mnożenie';

  @override
  String get selectMode => 'Wybierz tryb';

  @override
  String get selectReward => 'Wybierz nagrodę';

  @override
  String get rocketBuilder => 'Buduj rakietę';

  @override
  String get correct => 'Dobrze!';

  @override
  String get incorrect => 'Spróbuj jeszcze raz!';

  @override
  String get greatJob => 'Świetna robota!';

  @override
  String get rocketLaunched => 'Rakieta wystartowała!';

  @override
  String starsEarned(int count) {
    return 'Zdobyte gwiazdki: $count';
  }

  @override
  String get levelUp => 'Nowy poziom!';

  @override
  String get chooseUpgrade => 'Wybierz ulepszenie';

  @override
  String get settings => 'Ustawienia';

  @override
  String get parentalGate => 'Strefa rodzica';

  @override
  String parentalGateQuestion(int a, int b) {
    return 'Ile to jest $a × $b?';
  }

  @override
  String get resetProgress => 'Wyczyść postęp';

  @override
  String get resetConfirm => 'Czy na pewno chcesz wyczyścić cały postęp?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get back => 'Wróć';

  @override
  String get continueText => 'Dalej';

  @override
  String get play => 'Graj!';

  @override
  String get score => 'Wynik';

  @override
  String questionOf(int current, int total) {
    return 'Pytanie $current z $total';
  }

  @override
  String get additionUpTo10 => 'Dodawanie do 10';

  @override
  String get additionUpTo20 => 'Dodawanie do 20';

  @override
  String get additionUpTo100 => 'Dodawanie do 100';

  @override
  String get subtractionUpTo10 => 'Odejmowanie do 10';

  @override
  String get subtractionUpTo20 => 'Odejmowanie do 20';

  @override
  String get subtractionUpTo100 => 'Odejmowanie do 100';

  @override
  String get multiplicationBy2 => 'Tabliczka ×2';

  @override
  String get multiplicationBy3 => 'Tabliczka ×3';

  @override
  String get multiplicationBy4 => 'Tabliczka ×4';

  @override
  String get multiplicationBy5 => 'Tabliczka ×5';
}
