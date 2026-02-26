import 'package:flutter/material.dart';

enum BuildableType {
  rocket,
  car,
}

class BuildableModel {
  final String id;
  final String name;
  final String description;
  final BuildableType type;
  final Map<String, Color> colorScheme;
  final List<String> partNames;

  const BuildableModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.colorScheme,
    required this.partNames,
  });

  static const List<BuildableModel> rockets = [
    BuildableModel(
      id: 'classic',
      name: 'Klasyczna',
      description: 'Niezawodna rakieta kosmiczna',
      type: BuildableType.rocket,
      colorScheme: {
        'body1': Color(0xFFD0D8E8),
        'body2': Color(0xFF8899BB),
        'nose': Color(0xFFE94560),
        'fins': Color(0xFFE94560),
        'window': Color(0xFF00D4FF),
        'trim': Color(0xFFFFC947),
        'engine': Color(0xFF556677),
        'flame': Color(0xFFFFC947),
      },
      partNames: ['Kadłub', 'Dziób', 'Okno główne', 'Małe okno', 'Lewe skrzydło', 'Prawe skrzydło', 'Silnik', 'Antena', 'Oznaczenia', 'Napęd'],
    ),
    BuildableModel(
      id: 'stealth',
      name: 'Nocny Jastrząb',
      description: 'Szybka i niewidzialna',
      type: BuildableType.rocket,
      colorScheme: {
        'body1': Color(0xFF2D2D3D),
        'body2': Color(0xFF1A1A28),
        'nose': Color(0xFF6C5CE7),
        'fins': Color(0xFF6C5CE7),
        'window': Color(0xFFA29BFE),
        'trim': Color(0xFFA29BFE),
        'engine': Color(0xFF3D3D50),
        'flame': Color(0xFFA29BFE),
      },
      partNames: ['Kadłub', 'Dziób', 'Okno główne', 'Małe okno', 'Lewe skrzydło', 'Prawe skrzydło', 'Silnik', 'Antena', 'Oznaczenia', 'Napęd'],
    ),
    BuildableModel(
      id: 'solar',
      name: 'Złota Kometa',
      description: 'Napędzana energią słoneczną',
      type: BuildableType.rocket,
      colorScheme: {
        'body1': Color(0xFFFFEAA7),
        'body2': Color(0xFFFDCB6E),
        'nose': Color(0xFFE17055),
        'fins': Color(0xFFE17055),
        'window': Color(0xFF55A8E6),
        'trim': Color(0xFFE17055),
        'engine': Color(0xFFB87333),
        'flame': Color(0xFFFDCB6E),
      },
      partNames: ['Kadłub', 'Dziób', 'Okno główne', 'Małe okno', 'Lewy panel', 'Prawy panel', 'Silnik', 'Antena', 'Oznaczenia', 'Napęd'],
    ),
    BuildableModel(
      id: 'ice',
      name: 'Lodowy Piorun',
      description: 'Z mroźnej planety',
      type: BuildableType.rocket,
      colorScheme: {
        'body1': Color(0xFFDFE6E9),
        'body2': Color(0xFFB2BEC3),
        'nose': Color(0xFF0984E3),
        'fins': Color(0xFF0984E3),
        'window': Color(0xFF74B9FF),
        'trim': Color(0xFF74B9FF),
        'engine': Color(0xFF636E72),
        'flame': Color(0xFF74B9FF),
      },
      partNames: ['Kadłub', 'Dziób', 'Okno główne', 'Małe okno', 'Lewe skrzydło', 'Prawe skrzydło', 'Silnik', 'Antena', 'Oznaczenia', 'Napęd'],
    ),
  ];

  static const List<BuildableModel> cars = [
    BuildableModel(
      id: 'red',
      name: 'Czerwony Błysk',
      description: 'Klasyczny bolid F1',
      type: BuildableType.car,
      colorScheme: {
        'body': Color(0xFFE74C3C),
        'body2': Color(0xFFC0392B),
        'wing': Color(0xFFC0392B),
        'window': Color(0xFF5DADE2),
        'wheel': Color(0xFF333333),
        'rim': Color(0xFF888888),
        'stripe': Color(0xFFFFD740),
        'accent': Color(0xFFFF6B6B),
      },
      partNames: ['Nadwozie', 'Dziób', 'Kokpit', 'Tylne skrzydło', 'Lewe tylne koło', 'Prawe tylne koło', 'Lewe przednie koło', 'Prawe przednie koło', 'Malowanie', 'Wydech'],
    ),
    BuildableModel(
      id: 'blue',
      name: 'Niebieski Grom',
      description: 'Aerodynamiczny mistrz',
      type: BuildableType.car,
      colorScheme: {
        'body': Color(0xFF2D7FF9),
        'body2': Color(0xFF1A5DC0),
        'wing': Color(0xFF1A5DC0),
        'window': Color(0xFFA8D8FF),
        'wheel': Color(0xFF333333),
        'rim': Color(0xFFAAAAAA),
        'stripe': Color(0xFFFFFFFF),
        'accent': Color(0xFF74B9FF),
      },
      partNames: ['Nadwozie', 'Dziób', 'Kokpit', 'Tylne skrzydło', 'Lewe tylne koło', 'Prawe tylne koło', 'Lewe przednie koło', 'Prawe przednie koło', 'Malowanie', 'Wydech'],
    ),
    BuildableModel(
      id: 'green',
      name: 'Zielona Strzała',
      description: 'Ekologiczna potęga',
      type: BuildableType.car,
      colorScheme: {
        'body': Color(0xFF00C853),
        'body2': Color(0xFF009624),
        'wing': Color(0xFF009624),
        'window': Color(0xFFB2FF59),
        'wheel': Color(0xFF333333),
        'rim': Color(0xFF999999),
        'stripe': Color(0xFFFFD740),
        'accent': Color(0xFF69F0AE),
      },
      partNames: ['Nadwozie', 'Dziób', 'Kokpit', 'Tylne skrzydło', 'Lewe tylne koło', 'Prawe tylne koło', 'Lewe przednie koło', 'Prawe przednie koło', 'Malowanie', 'Wydech'],
    ),
    BuildableModel(
      id: 'purple',
      name: 'Fioletowy Cień',
      description: 'Tajemniczy nocny ścigacz',
      type: BuildableType.car,
      colorScheme: {
        'body': Color(0xFF9B59B6),
        'body2': Color(0xFF7D3C98),
        'wing': Color(0xFF7D3C98),
        'window': Color(0xFFD2B4DE),
        'wheel': Color(0xFF333333),
        'rim': Color(0xFFBBBBBB),
        'stripe': Color(0xFFF0C0FF),
        'accent': Color(0xFFC39BD3),
      },
      partNames: ['Nadwozie', 'Dziób', 'Kokpit', 'Tylne skrzydło', 'Lewe tylne koło', 'Prawe tylne koło', 'Lewe przednie koło', 'Prawe przednie koło', 'Malowanie', 'Wydech'],
    ),
  ];

  static List<BuildableModel> getByType(BuildableType type) {
    return type == BuildableType.rocket ? rockets : cars;
  }

  static BuildableModel? findById(String id) {
    for (final model in [...rockets, ...cars]) {
      if (model.id == id) return model;
    }
    return null;
  }
}
