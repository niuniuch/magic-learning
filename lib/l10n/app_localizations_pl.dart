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
  String get clockReading => 'Zegar';

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

  @override
  String get clockAmPm => 'Przed/po południu';

  @override
  String get clockElapsed => 'Ile czasu minęło?';

  @override
  String get clockFuture => 'Która będzie?';

  @override
  String get buildRocket => 'Zbuduj Rakietę!';

  @override
  String get buildCar => 'Zbuduj Wyścigówkę!';

  @override
  String get chooseRocket => 'Wybierz swoją rakietę!';

  @override
  String get chooseCar => 'Wybierz swoją wyścigówkę!';

  @override
  String get chooseUnique => 'Każda jest wyjątkowa — którą chcesz zbudować?';

  @override
  String get letsGo => 'BUDUJEMY!';

  @override
  String nextPart(String name) {
    return 'Następna część: $name';
  }

  @override
  String partsProgress(int current, int total) {
    return '$current / $total części';
  }

  @override
  String streakBonus(int multiplier) {
    return 'Seria ×$multiplier!';
  }

  @override
  String get statCorrect => 'Poprawne';

  @override
  String get statTime => 'Czas';

  @override
  String get statBestStreak => 'Najlepsza seria';

  @override
  String get statTotalQuestions => 'Pytań łącznie';

  @override
  String get mistakesReview => 'Powtórz to jeszcze raz:';

  @override
  String get playAgain => 'ZAGRAJ JESZCZE RAZ';

  @override
  String get backToMenu => 'Wróć do menu';

  @override
  String inSpace(String name) {
    return '$name w kosmosie!';
  }

  @override
  String atFinish(String name) {
    return '$name na mecie!';
  }

  @override
  String get rocketClassic => 'Klasyczna';

  @override
  String get rocketClassicDesc => 'Niezawodna rakieta kosmiczna';

  @override
  String get rocketStealth => 'Nocny Jastrząb';

  @override
  String get rocketStealthDesc => 'Szybka i niewidzialna';

  @override
  String get rocketSolar => 'Złota Kometa';

  @override
  String get rocketSolarDesc => 'Napędzana energią słoneczną';

  @override
  String get rocketIce => 'Lodowy Piorun';

  @override
  String get rocketIceDesc => 'Z mroźnej planety';

  @override
  String get carRed => 'Czerwony Błysk';

  @override
  String get carRedDesc => 'Klasyczny bolid F1';

  @override
  String get carBlue => 'Niebieski Grom';

  @override
  String get carBlueDesc => 'Aerodynamiczny mistrz';

  @override
  String get carGreen => 'Zielona Strzała';

  @override
  String get carGreenDesc => 'Ekologiczna potęga';

  @override
  String get carPurple => 'Fioletowy Cień';

  @override
  String get carPurpleDesc => 'Tajemniczy nocny ścigacz';

  @override
  String get rocketPartBody => 'Kadłub';

  @override
  String get rocketPartNose => 'Dziób';

  @override
  String get rocketPartMainWindow => 'Okno główne';

  @override
  String get rocketPartSmallWindow => 'Małe okno';

  @override
  String get rocketPartLeftFin => 'Lewe skrzydło';

  @override
  String get rocketPartRightFin => 'Prawe skrzydło';

  @override
  String get rocketPartEngine => 'Silnik';

  @override
  String get rocketPartAntenna => 'Antena';

  @override
  String get rocketPartMarkings => 'Oznaczenia';

  @override
  String get rocketPartFlame => 'Napęd';

  @override
  String get carPartBody => 'Nadwozie';

  @override
  String get carPartNose => 'Dziób';

  @override
  String get carPartCockpit => 'Kokpit';

  @override
  String get carPartRearWing => 'Tylne skrzydło';

  @override
  String get carPartLeftRearWheel => 'Lewe tylne koło';

  @override
  String get carPartRightRearWheel => 'Prawe tylne koło';

  @override
  String get carPartLeftFrontWheel => 'Lewe przednie koło';

  @override
  String get carPartRightFrontWheel => 'Prawe przednie koło';

  @override
  String get carPartStripes => 'Malowanie';

  @override
  String get carPartExhaust => 'Wydech';

  @override
  String get clockTimeNight => 'w nocy';

  @override
  String get clockTimeMorning => 'rano';

  @override
  String get clockTimeBeforeNoon => 'przed południem';

  @override
  String get clockTimeNoon => 'południe';

  @override
  String get clockTimeAfternoon => 'po południu';

  @override
  String get clockTimeEvening => 'wieczorem';

  @override
  String get clockTimeMidnight => 'północ';

  @override
  String get clockAmPmDesc => 'Podaj godzinę w zapisie 24h';

  @override
  String get clockElapsedDesc => 'Policz ile godzin minęło';

  @override
  String get clockFutureDesc => 'Oblicz przyszłą godzinę';
}
