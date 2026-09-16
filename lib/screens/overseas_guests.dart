import 'package:flutter/material.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/overseas_guests.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class OverseasGuestsScreen extends StatelessWidget {
  const OverseasGuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: WeddingAppBar(),
      drawer: AppDrawer(selectedIndex: 3),
      body: SingleChildScrollView(
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
