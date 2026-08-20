import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/ceremony.dart';
import 'package:wedding_website/widgets/introduction.dart';
import 'package:wedding_website/widgets/reception.dart';
import 'package:wedding_website/widgets/sign_off.dart';

final GlobalKey<MyHomePageState> homeKey = GlobalKey<MyHomePageState>();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);

  void scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
        elevation: 0,
        scrolledUnderElevation: 4,
        iconTheme: const IconThemeData(color: backgroundColor),
        title: const Text(
          "A & A",
          style: TextStyle(
            color: backgroundColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: const AppDrawer(selectedIndex: 0),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: const Column(
          children: [
            Introduction(),
            Ceremony(),
            Reception(),
            SignOff(),
          ],
        ),
      ),
    );
  }
}