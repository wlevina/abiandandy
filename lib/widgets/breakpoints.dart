import 'package:flutter/material.dart';

// Every screen used to switch its layout structure (row vs. column, drawer
// vs. side panel) at 600px but switch font/image sizing at 975px. Tablets
// like an iPad or Surface Pro land in that 600-975 gap, so they got the
// wide-layout structure with small-screen sizing — hence the "weird" look.
// One shared threshold keeps the two in sync everywhere.
const double mobileBreakpoint = 975;

bool isMobileWidth(BuildContext context) =>
    MediaQuery.of(context).size.width < mobileBreakpoint;

bool isDesktopWidth(BuildContext context) =>
    MediaQuery.of(context).size.width >= mobileBreakpoint;
