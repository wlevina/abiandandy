import 'package:flutter/material.dart';
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
