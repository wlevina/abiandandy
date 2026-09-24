import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_website/widgets/breakpoints.dart';
import 'package:wedding_website/widgets/precached_fade_in.dart';
import 'package:wedding_website/widgets/spacing.dart';
import 'package:wedding_website/widgets/squiggle_painter.dart';

class Reception extends StatelessWidget {
  const Reception({super.key});

  static const Color backgroundColor = Color(0xFF687351);
  static const Color creamColor = Color(0xFFF3F0E7);

  static const String googleMapsUrl =
      'https://maps.app.goo.gl/WQLLpgcZ6dcsmRCA6';

  Future<void> _launchMaps() async {
    final uri = Uri.parse(googleMapsUrl);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: isMobileBrowser ? '_self' : null,
    );
  }

  Widget _reception(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
          'Reception',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Madelyn',
            fontSize: titleTextSize,
            color: creamColor,
          ),
        ),
        SizedBox(height: gapSize),
      
        SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Events by Alpha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CoreBandiFace',
                  fontSize: venueTextSize,
                  color: creamColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'The Grand, 238 Castlereagh St, Sydney NSW',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'CoreBandiFace',
                  fontSize: addressTextSize,
                  color: creamColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SelectionContainer.disabled(
          child: MouseRegion(
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
        ),
        SizedBox(height: gapSize),
        SelectionArea(
          child: Text(
            'Cocktails from 5:30pm followed by dinner and dancing. After-party until late!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'CoreBandiFace',
              fontSize: detailsTextSize,
              color: creamColor,
              letterSpacing: 0.5,
            ),
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrecachedFadeIn(
                imagePaths: const ['assets/images/alpha_events.png'],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/alpha_events.png',
                    ),
                    Container(
                        padding: const EdgeInsets.all(2.0),
                        width: screenWidth * 0.8,
                        child: _reception(context)),
                  ],
                ),
              ),
              SizedBox(height: 230 * spacingScale(context)),
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
        child: SingleChildScrollView(
            child: Column(children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1800),
              child: PrecachedFadeIn(
                imagePaths: const ['assets/images/alpha_events.png'],
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            width: screenWidth,
                            height: heroHeight,
                            child: Image.asset(
                              'assets/images/alpha_events.png',
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
                                      child: _reception(context))))),
                  ],
                ),
              ),
            ),
          ),
          SquiggleDivider(
            width: screenWidth - dividerSize * 2,
            color: creamColor,
          ),
        ])),
      );
    }
  }
}