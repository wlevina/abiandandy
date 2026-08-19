import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/screens/faq.dart';
import 'package:wedding_website/screens/rsvp_form.dart';
import 'package:wedding_website/screens/wedding_agenda.dart';
import 'package:wedding_website/screens/overseas_guests.dart';
import 'package:wedding_website/widgets/ceremony.dart';
import 'package:wedding_website/widgets/introduction.dart';
import 'package:wedding_website/widgets/reception.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);

  static const List<String> _labels = [
    'Home',
    'RSVP',
    'Agenda',
    'Overseas Guests',
    'FAQ',
  ];

  Route<T> _fadeSlideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  void _handleNavigation(int index) {
    Navigator.pop(context); // Close drawer

    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        // Already on Home — nothing to push.
        setState(() => _selectedIndex = 0);
        break;

      case 1:
        Navigator.push(
          context,
          _fadeSlideRoute(const RsvpForm()),
        ).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
          _scaffoldKey.currentState?.openDrawer();
        });
        setState(() => _selectedIndex = 1);
        break;

      case 2:
        Navigator.push(
          context,
          _fadeSlideRoute(const WeddingAgenda()),
        ).then((_) {
          // Reset selection once the user returns to Home, so the drawer
          // doesn't keep "Agenda" highlighted after they've navigated back.
          if (mounted) setState(() => _selectedIndex = 0);
          _scaffoldKey.currentState?.openDrawer();
        });
        setState(() => _selectedIndex = 2);
        break;

      case 3:
        Navigator.push(
          context,
          _fadeSlideRoute(const OverseasGuestsScreen()),
        ).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
          _scaffoldKey.currentState?.openDrawer();
        });
        setState(() => _selectedIndex = 3);
        break;

      case 4:
        Navigator.push(
          context,
          _fadeSlideRoute(const Faq()),
        ).then((_) {
          if (mounted) setState(() => _selectedIndex = 0);
          _scaffoldKey.currentState?.openDrawer();
        });
        setState(() => _selectedIndex = 4);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        backgroundColor: backgroundColor,
        indicatorColor: const Color.fromRGBO(104, 115, 81, .5),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tilePadding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
        onDestinationSelected: _handleNavigation,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
            child: Text(
              'Menu',
              style: TextStyle(
                color: creamColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (final label in _labels)
            NavigationDrawerDestination(
              icon: const SizedBox.shrink(),
              selectedIcon: const SizedBox.shrink(),
              label: Text(
                label,
                style: const TextStyle(fontSize: 18, color: creamColor),
              ),
            ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
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