import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Reception extends StatelessWidget {
  const Reception({super.key});

  static const Color backgroundColor = Color(0xFF687351);
  static const Color creamColor = Color(0xFFF3F0E7);

  // TODO: replace with the real Google Maps link for the venue.
  static const String googleMapsUrl =
      'https://maps.app.goo.gl/WQLLpgcZ6dcsmRCA6';

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // Matches Introduction's spacing scale so the divider sits with the same
  // rhythm across Introduction/Ceremony/Reception on mobile.
  double _spacingScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / 1625).clamp(0.4, 1.0);
  }

  Future<void> _launchMaps() async {
    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _reception(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double titleTextSize = screenWidth > 975 ? 60.0 : 48.0;
    double detailsTextSize = screenWidth > 975 ? 21.0 : 18.0;
    double venueTextSize = screenWidth > 975 ? 27.0 : 27.0;
    double addressTextSize = screenWidth > 975 ? 21.0 : 18.0;
    double linkTextSize = screenWidth > 975 ? 15.0 : 16.0;

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
        const SizedBox(height: 25),
        Text(
          'Cocktails from 5:30pm',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: detailsTextSize,
            color: creamColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 25),
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
        const SizedBox(height: 10),
        GestureDetector(
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
        const SizedBox(height: 25),
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
              Image.asset(
                'assets/images/alpha_events.png',
              ),
              Container(
                  padding: const EdgeInsets.all(2.0),
                  width: screenWidth * 0.8,
                  child: _reception(context)),
              SizedBox(height: 180 * _spacingScale(context)),
              Divider(
                color: creamColor,
                indent: dividerSize,
                endIndent: dividerSize,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: backgroundColor,
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
                          height: screenHeight,
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
                                    padding: const EdgeInsets.all(100.0),
                                    child: _reception(context))))),
                ],
              ),
            ),
          ),
          Divider(
            color: creamColor,
            indent: dividerSize,
            endIndent: dividerSize,
          ),
        ])),
      );
    }
  }
}