import 'package:flutter/material.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class WeddingAgenda extends StatelessWidget {
  const WeddingAgenda({super.key});

  static const Color creamColor = Color(0xFFF3F0E7);

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  Widget _title(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 60.0 : 48.0;

    return Column(
      children: [
        Text(
          "Agenda",
          style:
              TextStyle(
                fontSize: titleTextSize,
                fontFamily: 'Madelyn')
        ),
      ],
    );
  }

  Widget _weddingDayTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 30.0 : 24.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(
          text: 'Ceremony',
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: titleTextSize
          )),
    );
  }

  Widget _ceremony(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'CoreBandiFace'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      SelectableText.rich(
        textAlign: TextAlign.left,
              TextSpan(children: [
          TextSpan(
              text: 'Date: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'Saturday, March 13th\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Location: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'The Mint\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Address: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: '10 Macquarie Street, Sydney NSW\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Time: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
                    text: 'Arrive by 12:00pm for a 12:30pm start\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: '\nDress Code: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'Formal', style: TextStyle(fontSize: detailsTextSize)),
        ]),
      ),
    ]),
    );
  }

  Widget _receptionTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 30.0 : 24.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(
          text: 'Reception',
          style: TextStyle(
            fontFamily: 'CoreBandiFace',
            fontSize: titleTextSize
          )),
    );
  }

  Widget _reception(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'CoreBandiFace'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      SelectableText.rich(
        textAlign: TextAlign.left,
        TextSpan(children: [
          //TextSpan(
          // text: 'recovery brunch\n',
          // style: TextStyle(
          //     fontSize: titleTextSize, fontWeight: FontWeight.normal)),
          TextSpan(
              text: 'Date: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'Saturday, March 13th\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Location: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'Events by Alpha\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Address: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'The Grand, 238 Castlereagh St, Sydney NSW\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: 'Time: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(
                    text:
                        'Cocktails from 5:30pm followed by dinner and dancing. After-party until late!\n',
              style: TextStyle(fontSize: detailsTextSize)),
          TextSpan(
              text: '\nDress Code: ',
              style: TextStyle(
                  fontSize: detailsTextSize, fontWeight: FontWeight.bold)),
          TextSpan(text: 'Formal', style: TextStyle(fontSize: detailsTextSize)),
        ]),
      ),
    ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isDesktop && isMobileWidth(context) || (isMobileWidth(context))) {
      return Scaffold(
          appBar: const WeddingAppBar(),
          drawer: const AppDrawer(selectedIndex: 2),
          body: SingleChildScrollView(
              child: Center(
                  child: Container(
            padding:
                const EdgeInsets.only(left: 50, top: 0, right: 50, bottom: 0),
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: creamColor, fontFamily: 'CoreBandiFace'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  _title(context),
                  const SizedBox(height: 50),
                  _weddingDayTitle(context),
                  const SizedBox(height: 12),
                  _ceremony(context),
                  SizedBox(height: screenHeight * 0.08),
                  _receptionTitle(context),
                  const SizedBox(height: 12),
                  _reception(context),
                  SizedBox(height: screenHeight * 0.1),
                  const SignOff()
                ],
              ),
            ),
          ))));
    } else {
      return Scaffold(
        appBar: const WeddingAppBar(),
        drawer: const AppDrawer(selectedIndex: 2),
        body: SingleChildScrollView(
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: creamColor, fontFamily: 'CoreBandiFace'),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .1),
                  _title(context),
                  SizedBox(height: screenHeight * .075),
                  _weddingDayTitle(context),
                  const SizedBox(height: 15),
                  SizedBox(width: 400, child: _ceremony(context)),
                  SizedBox(height: screenHeight * .075),
                  _receptionTitle(context),
                  const SizedBox(height: 15),
                  SizedBox(width: 400, child: _reception(context)),
                  const SignOff()
                ],
              ),
            ),
          ),
        ),

        //)
      );
    }
  }
}
