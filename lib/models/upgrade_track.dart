import 'package:flutter/material.dart';

enum UpgradeTrackId { headwear, accessory, aura }

class UpgradeStageConfig {
  final int stage; // 1-4
  final String name;
  final String description;

  const UpgradeStageConfig({
    required this.stage,
    required this.name,
    required this.description,
  });
}

class UpgradeTrackConfig {
  final UpgradeTrackId trackId;
  final String name;
  final IconData icon;
  final List<UpgradeStageConfig> stages; // exactly 4

  const UpgradeTrackConfig({
    required this.trackId,
    required this.name,
    required this.icon,
    required this.stages,
  });
}

class CharacterUpgradeConfig {
  final int characterIndex;
  final List<UpgradeTrackConfig> tracks; // exactly 3

  const CharacterUpgradeConfig({
    required this.characterIndex,
    required this.tracks,
  });

  static const List<CharacterUpgradeConfig> all = [
    // 0: Mage
    CharacterUpgradeConfig(
      characterIndex: 0,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Kapelusz',
          icon: Icons.auto_awesome,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Zwykły kapelusz', description: 'Prosty, spiczasty kapelusz'),
            UpgradeStageConfig(stage: 2, name: 'Kapelusz z gwiazdą', description: 'Gwiazda zdobi czubek'),
            UpgradeStageConfig(stage: 3, name: 'Świecący kapelusz', description: 'Kapelusz lśni magicznym blaskiem'),
            UpgradeStageConfig(stage: 4, name: 'Korona maga', description: 'Złota korona pełna mocy!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Laska',
          icon: Icons.bolt,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Drewniana laska', description: 'Prosta drewniana laska'),
            UpgradeStageConfig(stage: 2, name: 'Kryształowa laska', description: 'Kryształ na szczycie'),
            UpgradeStageConfig(stage: 3, name: 'Runowa laska', description: 'Runy zdobią trzon'),
            UpgradeStageConfig(stage: 4, name: 'Legendarna laska', description: 'Laska pełna starożytnej mocy!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Magia',
          icon: Icons.flare,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Iskierki', description: 'Drobne iskierki wokół'),
            UpgradeStageConfig(stage: 2, name: 'Gwiazdy', description: 'Gwiazdy krążą wokół'),
            UpgradeStageConfig(stage: 3, name: 'Runy', description: 'Magiczne runy unoszą się'),
            UpgradeStageConfig(stage: 4, name: 'Pełna aura', description: 'Potężna aura otacza maga!'),
          ],
        ),
      ],
    ),
    // 1: Fairy
    CharacterUpgradeConfig(
      characterIndex: 1,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Wianek',
          icon: Icons.local_florist,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Prosty wianek', description: 'Wianek z polnych kwiatów'),
            UpgradeStageConfig(stage: 2, name: 'Różany wianek', description: 'Róże zdobią wianek'),
            UpgradeStageConfig(stage: 3, name: 'Świecący wianek', description: 'Kwiaty lśnią magią'),
            UpgradeStageConfig(stage: 4, name: 'Korona kwiatów', description: 'Majestatyczna korona z kwiatów!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Skrzydła',
          icon: Icons.air,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Kropki', description: 'Wzór kropek na skrzydłach'),
            UpgradeStageConfig(stage: 2, name: 'Połysk', description: 'Skrzydła migoczą blaskiem'),
            UpgradeStageConfig(stage: 3, name: 'Ogień', description: 'Ogniste wzory na skrzydłach'),
            UpgradeStageConfig(stage: 4, name: 'Tęcza', description: 'Tęczowe skrzydła pełne magii!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Ślad różdżki',
          icon: Icons.auto_fix_high,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Iskierki', description: 'Iskierki za różdżką'),
            UpgradeStageConfig(stage: 2, name: 'Motyle', description: 'Motyle krążą wokół'),
            UpgradeStageConfig(stage: 3, name: 'Płatki', description: 'Płatki kwiatów wirują'),
            UpgradeStageConfig(stage: 4, name: 'Gwiezdny pył', description: 'Gwiezdny pył otacza wróżkę!'),
          ],
        ),
      ],
    ),
    // 2: Merperson
    CharacterUpgradeConfig(
      characterIndex: 2,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Korona',
          icon: Icons.diamond,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Koralowa opaska', description: 'Prosta opaska z korali'),
            UpgradeStageConfig(stage: 2, name: 'Muszlowa korona', description: 'Muszle zdobią koronę'),
            UpgradeStageConfig(stage: 3, name: 'Perłowa korona', description: 'Perły błyszczą w koronie'),
            UpgradeStageConfig(stage: 4, name: 'Królewska korona', description: 'Korona władcy oceanów!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Trójząb',
          icon: Icons.tsunami,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Drewniany trójząb', description: 'Prosty drewniany trójząb'),
            UpgradeStageConfig(stage: 2, name: 'Koralowy trójząb', description: 'Trójząb z żywego koralu'),
            UpgradeStageConfig(stage: 3, name: 'Kryształowy trójząb', description: 'Kryształy morskie lśnią'),
            UpgradeStageConfig(stage: 4, name: 'Legendarny trójząb', description: 'Trójząb pełen mocy oceanu!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Ocean',
          icon: Icons.water,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Bąbelki', description: 'Bąbelki unoszą się wokół'),
            UpgradeStageConfig(stage: 2, name: 'Perły', description: 'Perły krążą wokół'),
            UpgradeStageConfig(stage: 3, name: 'Prądy', description: 'Prądy morskie wirują'),
            UpgradeStageConfig(stage: 4, name: 'Wir wodny', description: 'Potężny wir otacza syrenkę!'),
          ],
        ),
      ],
    ),
    // 3: Superhero
    CharacterUpgradeConfig(
      characterIndex: 3,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Maska',
          icon: Icons.masks,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Prosta maska', description: 'Klasyczna maska superbohatera'),
            UpgradeStageConfig(stage: 2, name: 'Wzmocniona maska', description: 'Maska z metalowymi akcentami'),
            UpgradeStageConfig(stage: 3, name: 'Techno-maska', description: 'Zaawansowana technologicznie'),
            UpgradeStageConfig(stage: 4, name: 'Legendarna maska', description: 'Maska pełna mocy!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Peleryna',
          icon: Icons.style,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Gwiazda', description: 'Gwiazda na pelerynie'),
            UpgradeStageConfig(stage: 2, name: 'Błyskawice', description: 'Wzór błyskawic na pelerynie'),
            UpgradeStageConfig(stage: 3, name: 'Płomienie', description: 'Ogniste wzory na pelerynie'),
            UpgradeStageConfig(stage: 4, name: 'Kosmiczna', description: 'Kosmiczny wzór na pelerynie!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Moc',
          icon: Icons.flash_on,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Emblemat', description: 'Emblemat gwiazdy świeci'),
            UpgradeStageConfig(stage: 2, name: 'Błyskawice', description: 'Błyskawice z rękawic'),
            UpgradeStageConfig(stage: 3, name: 'Energia', description: 'Energia otacza bohatera'),
            UpgradeStageConfig(stage: 4, name: 'Złota moc', description: 'Złota aura superbohatra!'),
          ],
        ),
      ],
    ),
    // 4: Alien
    CharacterUpgradeConfig(
      characterIndex: 4,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Antena',
          icon: Icons.cell_tower,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Prosta antena', description: 'Podstawowa antena'),
            UpgradeStageConfig(stage: 2, name: 'Podwójna antena', description: 'Dwie anteny odbierają sygnały'),
            UpgradeStageConfig(stage: 3, name: 'Świecąca antena', description: 'Antena promieniuje energią'),
            UpgradeStageConfig(stage: 4, name: 'Kwantowa antena', description: 'Antena łączy z galaktyką!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Wizjer',
          icon: Icons.visibility,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Prosty wizjer', description: 'Podstawowy wizjer'),
            UpgradeStageConfig(stage: 2, name: 'Skan wizjer', description: 'Wizjer skanuje otoczenie'),
            UpgradeStageConfig(stage: 3, name: 'Holo wizjer', description: 'Holograficzny wyświetlacz'),
            UpgradeStageConfig(stage: 4, name: 'Kosmiczny wizjer', description: 'Wizjer widzi wszystko!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Technologia',
          icon: Icons.rocket_launch,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Poświata', description: 'Delikatna poświata wokół'),
            UpgradeStageConfig(stage: 2, name: 'Tarcza', description: 'Energetyczna tarcza'),
            UpgradeStageConfig(stage: 3, name: 'Hologram', description: 'Holograficzne projekcje'),
            UpgradeStageConfig(stage: 4, name: 'Zaawansowana tech', description: 'Pełnia kosmicznej technologii!'),
          ],
        ),
      ],
    ),
    // 5: Robot
    CharacterUpgradeConfig(
      characterIndex: 5,
      tracks: [
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.headwear,
          name: 'Moduł głowy',
          icon: Icons.memory,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Prosty moduł', description: 'Podstawowy moduł na głowie'),
            UpgradeStageConfig(stage: 2, name: 'Procesor', description: 'Dodatkowy procesor zamontowany'),
            UpgradeStageConfig(stage: 3, name: 'Turbo moduł', description: 'Turbodoładowany moduł'),
            UpgradeStageConfig(stage: 4, name: 'Kwantowy moduł', description: 'Kwantowy komputer na głowie!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.accessory,
          name: 'Ramiona',
          icon: Icons.build,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'Chwytaki', description: 'Proste chwytaki mechaniczne'),
            UpgradeStageConfig(stage: 2, name: 'Narzędzia', description: 'Wbudowane narzędzia w rękach'),
            UpgradeStageConfig(stage: 3, name: 'Lasery', description: 'Laserowe emitery w dłoniach'),
            UpgradeStageConfig(stage: 4, name: 'Mega-ramiona', description: 'Pełne uzbrojenie robotyczne!'),
          ],
        ),
        UpgradeTrackConfig(
          trackId: UpgradeTrackId.aura,
          name: 'Światła',
          icon: Icons.lightbulb,
          stages: [
            UpgradeStageConfig(stage: 1, name: 'LEDy', description: 'Diody LED na korpusie'),
            UpgradeStageConfig(stage: 2, name: 'Ekran', description: 'Ekran wyświetla emotki'),
            UpgradeStageConfig(stage: 3, name: 'Iskry', description: 'Iskry między przegubami'),
            UpgradeStageConfig(stage: 4, name: 'Złote światła', description: 'Złote wykończenie aktywne!'),
          ],
        ),
      ],
    ),
  ];

  static CharacterUpgradeConfig forCharacter(int index) => all[index % 6];
}
