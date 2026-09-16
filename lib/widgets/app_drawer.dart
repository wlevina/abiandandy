import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/api/sheets/rsvp_sheets_api.dart';
import 'package:wedding_website/home.dart';
import 'package:wedding_website/screens/faq.dart';
import 'package:wedding_website/screens/overseas_guests.dart';
import 'package:wedding_website/screens/rsvp_form.dart';
import 'package:wedding_website/screens/wedding_agenda.dart';

const List<String> kNavLabels = [
  'Home',
  'RSVP',
  'Agenda',
  'Overseas Guests',
  'FAQ',
];

Route<T> fadeSlideRoute<T>(Widget page) {
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

// Closes the drawer, then either returns to Home (scrolling it back to the
// top) or swaps the stack for the chosen page, so the back stack never grows
// past [Home, currentPage] no matter where navigation started from.
void navigateFromDrawer(BuildContext context, int index) {
  Navigator.pop(context);

  if (index == 0) {
    Navigator.popUntil(context, (route) => route.isFirst);
    homeKey.currentState?.scrollToTop();
    return;
  }

  if (index == 1) RsvpSheetsApi.warmUp();

  final Widget page = switch (index) {
    1 => const RsvpForm(),
    2 => const WeddingAgenda(),
    3 => const OverseasGuestsScreen(),
    4 => const Faq(),
    _ => throw ArgumentError('Unknown nav index $index'),
  };

  Navigator.pushAndRemoveUntil(
    context,
    fadeSlideRoute(page),
    (route) => route.isFirst,
  );
}

// Text alternative to the default hamburger icon, styled to match the
// site's display font. Opens the same drawer the icon would have.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: TextButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          style: TextButton.styleFrom(
            foregroundColor: backgroundColor,
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              fontFamily: 'CoreBandiFace',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class WeddingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeddingAppBar({super.key});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
      elevation: 0,
      scrolledUnderElevation: 4,
      iconTheme: const IconThemeData(color: backgroundColor),
      leading: const AppMenuButton(),
      leadingWidth: 90,
      title: const Text(
        "A & A",
        style: TextStyle(
          color: backgroundColor,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  const AppDrawer({super.key, required this.selectedIndex});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      backgroundColor: backgroundColor,
      indicatorColor: const Color.fromRGBO(104, 115, 81, .5),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tilePadding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
      onDestinationSelected: (index) => navigateFromDrawer(context, index),
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
        for (final label in kNavLabels)
          NavigationDrawerDestination(
            icon: const SizedBox.shrink(),
            selectedIcon: const SizedBox.shrink(),
            label: Text(
              label,
              style: const TextStyle(fontSize: 18, color: creamColor),
            ),
          ),
      ],
    );
  }
}
