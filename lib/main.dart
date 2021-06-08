import 'dart:async';
import 'package:fleet_management/app_translations.dart';
import 'package:fleet_management/app_translations_delegate.dart';
import 'package:fleet_management/application.dart';
import 'package:fleet_management/screens/dashboard.dart';
import 'package:fleet_management/screens/login_screen.dart';
import 'package:fleet_management/screens/splash_screen.dart';
import 'package:flutter/material.dart';

Future<Null> main() async {
  runApp(new LocalisedApp());
}

class LocalisedApp extends StatefulWidget {
  @override
  MyApp createState() {
    return new MyApp();
  }
}

class MyApp extends State<LocalisedApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        DashBoard.id: (context) => DashBoard(),
      },
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        // GlobalMaterialLocalizations.delegate,
        //provides RTL support
        // GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("de", ""),
        const Locale("en", ""),
      ],
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}

// import 'package:fleet_management/screens/dashboard.dart';
// import 'package:fleet_management/screens/login_screen.dart';
// import 'package:fleet_management/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SplashScreen(),
//       routes: {
//         SplashScreen.id: (context) => SplashScreen(),
//         LoginScreen.id: (context) => LoginScreen(),
//         DashBoard.id: (context) => DashBoard(),
//       },
//     );
//   }
// }
