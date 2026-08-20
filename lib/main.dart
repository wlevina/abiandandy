import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A & A',
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(),//titleTextStyle: TextStyle(color:Color(0xFFF3F0E7))),
        fontFamily: 'CoreBandiFace',
        scaffoldBackgroundColor: const Color.fromRGBO(104, 115, 81, 1),
        primaryColor:  const Color(0xFFF3F0E7),
        useMaterial3: false,
      ),
      home: MyHomePage(key: homeKey),
      debugShowCheckedModeBanner: false,
    );
  }
}
