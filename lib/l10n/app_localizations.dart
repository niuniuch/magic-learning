import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// No description provided for @appTitle.
  ///
  /// In pl, this message translates to:
  /// **'Magiczne Uczenie'**
  String get appTitle;

  /// No description provided for @createAvatar.
  ///
  /// In pl, this message translates to:
  /// **'Stwórz swoją postać'**
  String get createAvatar;

  /// No description provided for @chooseCharacter.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz postać'**
  String get chooseCharacter;

  /// No description provided for @enterName.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz imię'**
  String get enterName;

  /// No description provided for @namePlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'Twoje imię...'**
  String get namePlaceholder;

  /// No description provided for @start.
  ///
  /// In pl, this message translates to:
  /// **'Start!'**
  String get start;

  /// No description provided for @level.
  ///
  /// In pl, this message translates to:
  /// **'Poziom'**
  String get level;

  /// No description provided for @stars.
  ///
  /// In pl, this message translates to:
  /// **'Gwiazdki'**
  String get stars;

  /// No description provided for @miniGameHub.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz grę'**
  String get miniGameHub;

  /// No description provided for @addition.
  ///
  /// In pl, this message translates to:
  /// **'Dodawanie'**
  String get addition;

  /// No description provided for @subtraction.
  ///
  /// In pl, this message translates to:
  /// **'Odejmowanie'**
  String get subtraction;

  /// No description provided for @multiplication.
  ///
  /// In pl, this message translates to:
  /// **'Mnożenie'**
  String get multiplication;

  /// No description provided for @clockReading.
  ///
  /// In pl, this message translates to:
  /// **'Zegar'**
  String get clockReading;

  /// No description provided for @selectMode.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz tryb'**
  String get selectMode;

  /// No description provided for @selectReward.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz nagrodę'**
  String get selectReward;

  /// No description provided for @rocketBuilder.
  ///
  /// In pl, this message translates to:
  /// **'Buduj rakietę'**
  String get rocketBuilder;

  /// No description provided for @correct.
  ///
  /// In pl, this message translates to:
  /// **'Dobrze!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj jeszcze raz!'**
  String get incorrect;

  /// No description provided for @greatJob.
  ///
  /// In pl, this message translates to:
  /// **'Świetna robota!'**
  String get greatJob;

  /// No description provided for @rocketLaunched.
  ///
  /// In pl, this message translates to:
  /// **'Rakieta wystartowała!'**
  String get rocketLaunched;

  /// No description provided for @starsEarned.
  ///
  /// In pl, this message translates to:
  /// **'Zdobyte gwiazdki: {count}'**
  String starsEarned(int count);

  /// No description provided for @levelUp.
  ///
  /// In pl, this message translates to:
  /// **'Nowy poziom!'**
  String get levelUp;

  /// No description provided for @chooseUpgrade.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz ulepszenie'**
  String get chooseUpgrade;

  /// No description provided for @settings.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settings;

  /// No description provided for @parentalGate.
  ///
  /// In pl, this message translates to:
  /// **'Strefa rodzica'**
  String get parentalGate;

  /// No description provided for @parentalGateQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Ile to jest {a} × {b}?'**
  String parentalGateQuestion(int a, int b);

  /// No description provided for @resetProgress.
  ///
  /// In pl, this message translates to:
  /// **'Wyczyść postęp'**
  String get resetProgress;

  /// No description provided for @resetConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz wyczyścić cały postęp?'**
  String get resetConfirm;

  /// No description provided for @yes.
  ///
  /// In pl, this message translates to:
  /// **'Tak'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pl, this message translates to:
  /// **'Nie'**
  String get no;

  /// No description provided for @back.
  ///
  /// In pl, this message translates to:
  /// **'Wróć'**
  String get back;

  /// No description provided for @continueText.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get continueText;

  /// No description provided for @play.
  ///
  /// In pl, this message translates to:
  /// **'Graj!'**
  String get play;

  /// No description provided for @score.
  ///
  /// In pl, this message translates to:
  /// **'Wynik'**
  String get score;

  /// No description provided for @questionOf.
  ///
  /// In pl, this message translates to:
  /// **'Pytanie {current} z {total}'**
  String questionOf(int current, int total);

  /// No description provided for @additionUpTo10.
  ///
  /// In pl, this message translates to:
  /// **'Dodawanie do 10'**
  String get additionUpTo10;

  /// No description provided for @additionUpTo20.
  ///
  /// In pl, this message translates to:
  /// **'Dodawanie do 20'**
  String get additionUpTo20;

  /// No description provided for @additionUpTo100.
  ///
  /// In pl, this message translates to:
  /// **'Dodawanie do 100'**
  String get additionUpTo100;

  /// No description provided for @subtractionUpTo10.
  ///
  /// In pl, this message translates to:
  /// **'Odejmowanie do 10'**
  String get subtractionUpTo10;

  /// No description provided for @subtractionUpTo20.
  ///
  /// In pl, this message translates to:
  /// **'Odejmowanie do 20'**
  String get subtractionUpTo20;

  /// No description provided for @subtractionUpTo100.
  ///
  /// In pl, this message translates to:
  /// **'Odejmowanie do 100'**
  String get subtractionUpTo100;

  /// No description provided for @multiplicationBy2.
  ///
  /// In pl, this message translates to:
  /// **'Tabliczka ×2'**
  String get multiplicationBy2;

  /// No description provided for @multiplicationBy3.
  ///
  /// In pl, this message translates to:
  /// **'Tabliczka ×3'**
  String get multiplicationBy3;

  /// No description provided for @multiplicationBy4.
  ///
  /// In pl, this message translates to:
  /// **'Tabliczka ×4'**
  String get multiplicationBy4;

  /// No description provided for @multiplicationBy5.
  ///
  /// In pl, this message translates to:
  /// **'Tabliczka ×5'**
  String get multiplicationBy5;

  /// No description provided for @clockAmPm.
  ///
  /// In pl, this message translates to:
  /// **'Przed/po południu'**
  String get clockAmPm;

  /// No description provided for @clockElapsed.
  ///
  /// In pl, this message translates to:
  /// **'Ile czasu minęło?'**
  String get clockElapsed;

  /// No description provided for @clockFuture.
  ///
  /// In pl, this message translates to:
  /// **'Która będzie?'**
  String get clockFuture;

  /// No description provided for @buildRocket.
  ///
  /// In pl, this message translates to:
  /// **'Zbuduj Rakietę!'**
  String get buildRocket;

  /// No description provided for @buildCar.
  ///
  /// In pl, this message translates to:
  /// **'Zbuduj Wyścigówkę!'**
  String get buildCar;

  /// No description provided for @chooseRocket.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz swoją rakietę!'**
  String get chooseRocket;

  /// No description provided for @chooseCar.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz swoją wyścigówkę!'**
  String get chooseCar;

  /// No description provided for @chooseUnique.
  ///
  /// In pl, this message translates to:
  /// **'Każda jest wyjątkowa — którą chcesz zbudować?'**
  String get chooseUnique;

  /// No description provided for @letsGo.
  ///
  /// In pl, this message translates to:
  /// **'BUDUJEMY!'**
  String get letsGo;

  /// No description provided for @nextPart.
  ///
  /// In pl, this message translates to:
  /// **'Następna część: {name}'**
  String nextPart(String name);

  /// No description provided for @partsProgress.
  ///
  /// In pl, this message translates to:
  /// **'{current} / {total} części'**
  String partsProgress(int current, int total);

  /// No description provided for @streakBonus.
  ///
  /// In pl, this message translates to:
  /// **'Seria ×{multiplier}!'**
  String streakBonus(int multiplier);

  /// No description provided for @statCorrect.
  ///
  /// In pl, this message translates to:
  /// **'Poprawne'**
  String get statCorrect;

  /// No description provided for @statTime.
  ///
  /// In pl, this message translates to:
  /// **'Czas'**
  String get statTime;

  /// No description provided for @statBestStreak.
  ///
  /// In pl, this message translates to:
  /// **'Najlepsza seria'**
  String get statBestStreak;

  /// No description provided for @statTotalQuestions.
  ///
  /// In pl, this message translates to:
  /// **'Pytań łącznie'**
  String get statTotalQuestions;

  /// No description provided for @mistakesReview.
  ///
  /// In pl, this message translates to:
  /// **'Powtórz to jeszcze raz:'**
  String get mistakesReview;

  /// No description provided for @playAgain.
  ///
  /// In pl, this message translates to:
  /// **'ZAGRAJ JESZCZE RAZ'**
  String get playAgain;

  /// No description provided for @backToMenu.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do menu'**
  String get backToMenu;

  /// No description provided for @inSpace.
  ///
  /// In pl, this message translates to:
  /// **'{name} w kosmosie!'**
  String inSpace(String name);

  /// No description provided for @atFinish.
  ///
  /// In pl, this message translates to:
  /// **'{name} na mecie!'**
  String atFinish(String name);

  /// No description provided for @rocketClassic.
  ///
  /// In pl, this message translates to:
  /// **'Klasyczna'**
  String get rocketClassic;

  /// No description provided for @rocketClassicDesc.
  ///
  /// In pl, this message translates to:
  /// **'Niezawodna rakieta kosmiczna'**
  String get rocketClassicDesc;

  /// No description provided for @rocketStealth.
  ///
  /// In pl, this message translates to:
  /// **'Nocny Jastrząb'**
  String get rocketStealth;

  /// No description provided for @rocketStealthDesc.
  ///
  /// In pl, this message translates to:
  /// **'Szybka i niewidzialna'**
  String get rocketStealthDesc;

  /// No description provided for @rocketSolar.
  ///
  /// In pl, this message translates to:
  /// **'Złota Kometa'**
  String get rocketSolar;

  /// No description provided for @rocketSolarDesc.
  ///
  /// In pl, this message translates to:
  /// **'Napędzana energią słoneczną'**
  String get rocketSolarDesc;

  /// No description provided for @rocketIce.
  ///
  /// In pl, this message translates to:
  /// **'Lodowy Piorun'**
  String get rocketIce;

  /// No description provided for @rocketIceDesc.
  ///
  /// In pl, this message translates to:
  /// **'Z mroźnej planety'**
  String get rocketIceDesc;

  /// No description provided for @carRed.
  ///
  /// In pl, this message translates to:
  /// **'Czerwony Błysk'**
  String get carRed;

  /// No description provided for @carRedDesc.
  ///
  /// In pl, this message translates to:
  /// **'Klasyczny bolid F1'**
  String get carRedDesc;

  /// No description provided for @carBlue.
  ///
  /// In pl, this message translates to:
  /// **'Niebieski Grom'**
  String get carBlue;

  /// No description provided for @carBlueDesc.
  ///
  /// In pl, this message translates to:
  /// **'Aerodynamiczny mistrz'**
  String get carBlueDesc;

  /// No description provided for @carGreen.
  ///
  /// In pl, this message translates to:
  /// **'Zielona Strzała'**
  String get carGreen;

  /// No description provided for @carGreenDesc.
  ///
  /// In pl, this message translates to:
  /// **'Ekologiczna potęga'**
  String get carGreenDesc;

  /// No description provided for @carPurple.
  ///
  /// In pl, this message translates to:
  /// **'Fioletowy Cień'**
  String get carPurple;

  /// No description provided for @carPurpleDesc.
  ///
  /// In pl, this message translates to:
  /// **'Tajemniczy nocny ścigacz'**
  String get carPurpleDesc;

  /// No description provided for @rocketPartBody.
  ///
  /// In pl, this message translates to:
  /// **'Kadłub'**
  String get rocketPartBody;

  /// No description provided for @rocketPartNose.
  ///
  /// In pl, this message translates to:
  /// **'Dziób'**
  String get rocketPartNose;

  /// No description provided for @rocketPartMainWindow.
  ///
  /// In pl, this message translates to:
  /// **'Okno główne'**
  String get rocketPartMainWindow;

  /// No description provided for @rocketPartSmallWindow.
  ///
  /// In pl, this message translates to:
  /// **'Małe okno'**
  String get rocketPartSmallWindow;

  /// No description provided for @rocketPartLeftFin.
  ///
  /// In pl, this message translates to:
  /// **'Lewe skrzydło'**
  String get rocketPartLeftFin;

  /// No description provided for @rocketPartRightFin.
  ///
  /// In pl, this message translates to:
  /// **'Prawe skrzydło'**
  String get rocketPartRightFin;

  /// No description provided for @rocketPartEngine.
  ///
  /// In pl, this message translates to:
  /// **'Silnik'**
  String get rocketPartEngine;

  /// No description provided for @rocketPartAntenna.
  ///
  /// In pl, this message translates to:
  /// **'Antena'**
  String get rocketPartAntenna;

  /// No description provided for @rocketPartMarkings.
  ///
  /// In pl, this message translates to:
  /// **'Oznaczenia'**
  String get rocketPartMarkings;

  /// No description provided for @rocketPartFlame.
  ///
  /// In pl, this message translates to:
  /// **'Napęd'**
  String get rocketPartFlame;

  /// No description provided for @carPartBody.
  ///
  /// In pl, this message translates to:
  /// **'Nadwozie'**
  String get carPartBody;

  /// No description provided for @carPartNose.
  ///
  /// In pl, this message translates to:
  /// **'Dziób'**
  String get carPartNose;

  /// No description provided for @carPartCockpit.
  ///
  /// In pl, this message translates to:
  /// **'Kokpit'**
  String get carPartCockpit;

  /// No description provided for @carPartRearWing.
  ///
  /// In pl, this message translates to:
  /// **'Tylne skrzydło'**
  String get carPartRearWing;

  /// No description provided for @carPartLeftRearWheel.
  ///
  /// In pl, this message translates to:
  /// **'Lewe tylne koło'**
  String get carPartLeftRearWheel;

  /// No description provided for @carPartRightRearWheel.
  ///
  /// In pl, this message translates to:
  /// **'Prawe tylne koło'**
  String get carPartRightRearWheel;

  /// No description provided for @carPartLeftFrontWheel.
  ///
  /// In pl, this message translates to:
  /// **'Lewe przednie koło'**
  String get carPartLeftFrontWheel;

  /// No description provided for @carPartRightFrontWheel.
  ///
  /// In pl, this message translates to:
  /// **'Prawe przednie koło'**
  String get carPartRightFrontWheel;

  /// No description provided for @carPartStripes.
  ///
  /// In pl, this message translates to:
  /// **'Malowanie'**
  String get carPartStripes;

  /// No description provided for @carPartExhaust.
  ///
  /// In pl, this message translates to:
  /// **'Wydech'**
  String get carPartExhaust;

  /// No description provided for @clockTimeNight.
  ///
  /// In pl, this message translates to:
  /// **'w nocy'**
  String get clockTimeNight;

  /// No description provided for @clockTimeMorning.
  ///
  /// In pl, this message translates to:
  /// **'rano'**
  String get clockTimeMorning;

  /// No description provided for @clockTimeBeforeNoon.
  ///
  /// In pl, this message translates to:
  /// **'przed południem'**
  String get clockTimeBeforeNoon;

  /// No description provided for @clockTimeNoon.
  ///
  /// In pl, this message translates to:
  /// **'południe'**
  String get clockTimeNoon;

  /// No description provided for @clockTimeAfternoon.
  ///
  /// In pl, this message translates to:
  /// **'po południu'**
  String get clockTimeAfternoon;

  /// No description provided for @clockTimeEvening.
  ///
  /// In pl, this message translates to:
  /// **'wieczorem'**
  String get clockTimeEvening;

  /// No description provided for @clockTimeMidnight.
  ///
  /// In pl, this message translates to:
  /// **'północ'**
  String get clockTimeMidnight;

  /// No description provided for @clockAmPmDesc.
  ///
  /// In pl, this message translates to:
  /// **'Podaj godzinę w zapisie 24h'**
  String get clockAmPmDesc;

  /// No description provided for @clockElapsedDesc.
  ///
  /// In pl, this message translates to:
  /// **'Policz ile godzin minęło'**
  String get clockElapsedDesc;

  /// No description provided for @clockFutureDesc.
  ///
  /// In pl, this message translates to:
  /// **'Oblicz przyszłą godzinę'**
  String get clockFutureDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
