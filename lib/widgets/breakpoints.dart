import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
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

// True when running in a mobile browser (as opposed to a desktop browser or
// a narrow desktop window). Flutter web infers this from the user agent, so
// unlike isMobileWidth it doesn't need a BuildContext and isn't affected by
// window resizing.
bool get isMobileBrowser =>
    kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
