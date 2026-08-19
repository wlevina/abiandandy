import 'package:flutter/material.dart';

class SignOff extends StatelessWidget {
  const SignOff({super.key});

  static const Color creamColor = Color(0xFFF3F0E7);

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  Widget _signOff(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double titleTextSize = screenWidth > 975 ? 60.0 : 48.0;
    double detailsTextSize = screenWidth > 975 ? 30.0 : 21.0;
    double dividerSize = screenWidth > 975 ? screenWidth * 0.4 : screenWidth * 0.25;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text.rich(
        textAlign: TextAlign.center,
        TextSpan(text: 'A & A', style: TextStyle(fontFamily: 'Madelyn', fontSize: titleTextSize, color: creamColor)),
      ),
      Divider(
        color: creamColor,
        indent: dividerSize,
        endIndent: dividerSize,
      ),
      Text.rich(
        textAlign: TextAlign.left,
        TextSpan(children: [
          TextSpan(
              text: '13.03.2027\n',
              style: TextStyle(fontSize: detailsTextSize, color: creamColor)),
        ]),
      ),
      //const SizedBox(height: 30),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isDesktop && isMobileWidth(context) || (isMobileWidth(context))) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
                //height: screenHeight * .2,
                padding: const EdgeInsets.all(2.0),
                //width: screenWidth * .8,
                child: Column(
                  children: [_signOff(context)],
                )),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Row(children: [
          if (isDesktopWidth(context))
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: screenHeight * 1,
                    child: _signOff(context))),
        ]),
      );
    }
  }
}
