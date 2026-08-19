import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/widgets/overseas_guests.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class OverseasGuestsScreen extends StatelessWidget {
  const OverseasGuestsScreen({super.key});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);

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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            OverseasGuests(),
            SignOff(),
          ],
        ),
      ),
    );
  }
}
