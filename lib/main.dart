
import 'package:app/choice_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'const.dart';
import 'util/app_locations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales){
        for(var supportedLocale in supportedLocales){
          if(supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode){
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pt', 'BR')],
      title: 'Genius 7',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      home: ChooseTypeAccount(),
      debugShowCheckedModeBanner: false,
    );
  }
}