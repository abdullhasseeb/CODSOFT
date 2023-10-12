import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/screens/demo.dart';
import 'package:to_do_app/screens/home.dart';

import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor myCustomSwatchColor = MaterialColor(
        0xffFFBB5C,
    {
      50: Color(0xFFE0F2F1),
      100: Color(0xFFB2DFDB),
      200: Color(0xFF80CBC4),
      300: Color(0xFF4DB6AC),
      400: Color(0xFF26A69A),
      500: Color(0xff4f785a), // Primary color
      600: Color(0xFF00897B),
      700: Color(0xFF00796B),
      800: Color(0xFF00695C),
      900: Color(0xFF004D40),
    }
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'MondayRain',
        primaryColor: tdYellow,
        primarySwatch: myCustomSwatchColor,

      ),
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}
