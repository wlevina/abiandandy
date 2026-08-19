import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class WeddingAgenda extends StatelessWidget {
  const WeddingAgenda({super.key});

  static const Color backgroundColor = Color(0xFF687351);
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
    double titleTextSize = screenWidth(context) > 975 ? 45.0 : 36.0;

    return Text.rich(
      textAlign: TextAlign.left,
      TextSpan(
          text: 'Ceremony',
          style: TextStyle(
            fontFamily: 'Madelyn',
            fontSize: titleTextSize
          )),
    );
  }

  Widget _weddingDay(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'CoreBandiFace'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text.rich(
        textAlign: TextAlign.left,
        TextSpan(children: [
          // TextSpan(
          //     text: 'wedding day\n',
          //     style: TextStyle(
          //         fontSize: titleTextSize, fontWeight: FontWeight.normal)),
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
              text: 'Arrive by 12:15pm for a 12:30pm start\n',
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

  Widget _recoveryTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 45.0 : 36.0;

    return Text.rich(
      textAlign: TextAlign.left,
      TextSpan(
          text: 'Reception',
          style: TextStyle(
            fontFamily: 'Madelyn',
            fontSize: titleTextSize
          )),
    );
  }

  Widget _recoveryBrunch(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'CoreBandiFace'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text.rich(
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
              text: 'Cocktails from 5:30pm\n',
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
          appBar: AppBar(
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.white),
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
              elevation: 0,
              scrolledUnderElevation: 4,
              iconTheme: const IconThemeData(color: backgroundColor),
              title: const Text(
                "A & A",
                style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
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
                  _weddingDay(context),
                  SizedBox(height: screenHeight * 0.08),
                  _recoveryTitle(context),
                  const SizedBox(height: 12),
                  _recoveryBrunch(context),
                  SizedBox(height: screenHeight * 0.1),
                  const SignOff()
                ],
              ),
            ),
          ))));
    } else {
      return Scaffold(
        appBar: AppBar(
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.white),
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(243, 240, 231, 0.75),
            elevation: 0,
            scrolledUnderElevation: 4,
            iconTheme: const IconThemeData(color: backgroundColor),
            title: const Text(
              "A & A",
              style: TextStyle(
                  color: backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            )),
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
                  SizedBox(width: 400, child: _weddingDay(context)),
                  SizedBox(height: screenHeight * .075),
                  _recoveryTitle(context),
                  SizedBox(width: 400, child: _recoveryBrunch(context)),
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
