import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_website/widgets/spacing.dart';
import 'package:wedding_website/widgets/squiggle_painter.dart';

class Ceremony extends StatelessWidget {
  const Ceremony({super.key});

  static const Color backgroundColor = Color(0xFF687351);
  static const Color creamColor = Color(0xFFF3F0E7);

  static const String googleMapsUrl =
      'https://maps.app.goo.gl/aSrjmY8d2umRF9Az6';

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  Future<void> _launchMaps() async {
    final uri = Uri.parse(googleMapsUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _ceremony(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // NOTE: swap 'Ceremony' below to whatever font family matches the
    // script title in your screenshot (e.g. the same one used for
    // "Abi & Andy" if it's the same font, or a different script font
    // if it's a distinct one — let me know the font name and I'll update it).
    double titleTextSize = screenWidth > 975 ? 60.0 : 48.0;
    double detailsTextSize = screenWidth > 975 ? 21.0 : 18.0;
    double venueTextSize = screenWidth > 975 ? 27.0 : 27.0;
    double addressTextSize = screenWidth > 975 ? 21.0 : 18.0;
    double linkTextSize = screenWidth > 975 ? 15.0 : 16.0;
    double gapSize = 25.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ceremony',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Madelyn',
            fontSize: titleTextSize,
            color: creamColor,
          ),
        ),
        SizedBox(height: gapSize),

        SelectableText(
          'The Mint',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: venueTextSize,
            color: creamColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          '10 Macquarie Street, Sydney NSW',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: addressTextSize,
            color: creamColor,
          ),
        ),
        const SizedBox(height: 10),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _launchMaps,
            child: Text(
              'View on Google maps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: linkTextSize,
                color: creamColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        SizedBox(height: gapSize),
        SelectableText(
          'Please arrive by 12:00pm for a 12:30pm start',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: detailsTextSize,
            color: creamColor,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: gapSize),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS;
    double dividerSize = screenWidth > 975 ? screenWidth * 0.35 : screenWidth * 0.2;

    if (isDesktop && isMobileWidth(context) || (isMobileWidth(context))) {
      return Container(
        color: backgroundColor,
        constraints: BoxConstraints(minHeight: screenHeight),
        padding: EdgeInsets.only(bottom: spacingScale(context)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/the_mint.png',
              ),
              Container(
                  padding: const EdgeInsets.all(2.0),
                  width: screenWidth * 0.8,
                  child: _ceremony(context)),
              SizedBox(height: 220 * spacingScale(context)),
              SquiggleDivider(
                width: screenWidth - dividerSize * 2,
                color: creamColor,
              ),
            ],
          ),
        ),
      );
    } else {
      double heroHeight = screenHeight * .52;

      return Container(
        color: backgroundColor,
        //padding: EdgeInsets.only(bottom: spacingScale(context)),
        child: SingleChildScrollView(
            child: Column(children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1800),
              child: Row(
                children: [
                  Expanded(
                      child: SizedBox(
                          width: screenWidth,
                          height: heroHeight,
                          child: Image.asset(
                            'assets/images/the_mint.png',
                          ))),
                  if (isDesktopWidth(context))
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 550),
                                child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: _ceremony(context))))),
                ],
              ),
            ),
          ),
        ])),
      );
    }
  }
}