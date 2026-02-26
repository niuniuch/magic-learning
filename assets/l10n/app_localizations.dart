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
