import 'package:flutter/material.dart';

class Location{
  Location(this.locale);

  final Locale locale;

  static Location of(BuildContext context) {
    return Localizations.of<Location>(context, Location);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'pt': {
      'title': 'Olá Mundo',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
}