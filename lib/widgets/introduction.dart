import 'package:flutter/material.dart';
import 'package:wedding_website/screens/rsvp_form.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/squiggle_painter.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // On short viewports (e.g. a laptop browser window), whitespace shrinks
  // hard first — it's cheap to cut — while the title/images/text only
  // shrink a little, so the section still fits without scrolling but
  // doesn't look shrunken. Both stay at 1.0 on tall screens.
  double _contentScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / 1312.5).clamp(0.68, 1.0);
  }

  // Text barely affects the vertical budget compared to the title/champagne
  // images, so it can stay much closer to full size without bringing back
  // the RSVP overflow — a higher floor keeps it legible on short screens.
  double _textScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double scale = screenHeight / 1312.5;
    return isMobileWidth(context) ? scale.clamp(1.0, 1.15) : scale.clamp(0.85, 1.0);
  }

  double _spacingScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / 1625).clamp(0.4, 1.0);
  }

  // Small hand-drawn-style squiggle used under the date/location text.
  Widget _squiggle({double width = 90}) {
    return SquiggleDivider(width: width, height: 14, color: creamColor);
  }

  Widget _title(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleWidth = (screenWidth > 975 ? 825.0 : 350.0) * _contentScale(context);

    return Image.asset(
      'assets/images/abi_and_andy_title.png',
      width: titleWidth,
      fit: BoxFit.contain,
    );
  }

  Widget _detailsRow(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double spacingScale = _spacingScale(context);
    double labelSize = (screenWidth > 975 ? 22.5 : 18.0) * _textScale(context);
    double letterSpacing = 1.5;

    final textStyle = TextStyle(
      fontFamily: 'CoreBandiFace',
      fontSize: labelSize,
      color: creamColor,
      letterSpacing: letterSpacing,
      height: 1.5,
    );

    final dateColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('13 MARCH 2027', style: textStyle),
        Text('AT 12:00 PM', style: textStyle),
        const SizedBox(height: 6),
        _squiggle(),
      ],
    );

    final locationColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('SYDNEY', style: textStyle),
        Text('AUSTRALIA', style: textStyle),
        const SizedBox(height: 6),
        _squiggle(),
      ],
    );

    if (isMobileWidth(context)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dateColumn,
          SizedBox(height: 20 * spacingScale),
          _centerImage(context),
          SizedBox(height: 20 * spacingScale),
          locationColumn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Align(alignment: Alignment.centerLeft, child: dateColumn)),
        _centerImage(context),
        Expanded(child: Align(alignment: Alignment.centerRight, child: locationColumn)),
      ],
    );
  }

  Widget _centerImage(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = (screenWidth > 975 ? 325.0 : 180.0) * _contentScale(context);

    return Image.asset(
      'assets/images/champagne_home.png',
      width: imageWidth,
      fit: BoxFit.contain,
    );
  }

  Widget _inviteLine(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = (screenWidth > 975 ? 20.0 : 16.0) * _textScale(context);

    return Text(
      'WE CORDIALLY INVITE YOU TO CELEBRATE OUR MARRIAGE TOGETHER WITH OUR FAMILIES',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'CoreBandiFace',
        fontSize: fontSize,
        color: creamColor,
        letterSpacing: 1.2,
        height: 1.6,
      ),
    );
  }

  Widget _countDown(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double countdownSize = (screenWidth > 975 ? 22.5 : 16.5) * _textScale(context);

    final dday = DateTime(2027, 3, 13);
    final today = DateTime.now();
    final difference = dday.difference(today).inDays;

    var ddayText = difference > 0 ? '$difference DAYS TO GO!' : '';

    if (ddayText.isEmpty) return const SizedBox.shrink();

    return Text(
      ddayText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'CoreBandiFace',
        fontSize: countdownSize,
        fontWeight: FontWeight.bold,
        color: creamColor,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _rsvp(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScale = _textScale(context);
    double rsvpTextSize = (screenWidth > 975 ? 25.0 : 24.0) * textScale;

    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, fadeSlideRoute(const RsvpForm()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: creamColor,
        foregroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
            horizontal: 48, vertical: 18 * textScale),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 0,
      ),
      child: Text(
        'RSVP',
        style: TextStyle(
          fontFamily: 'CoreBandiFace',
          fontSize: rsvpTextSize,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _invitation(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double spacingScale = _spacingScale(context);
    double horizontalPadding = screenWidth > 975 ? 75 : 24;
    double wideWidth =
        (screenWidth > 975 ? 1250 : 500) * _contentScale(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: wideWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(context),
            _detailsRow(context),
            SizedBox(height: 60 * spacingScale),
            _inviteLine(context),
            SizedBox(height: 44 * spacingScale),
            _countDown(context),
            SizedBox(height: 56 * spacingScale),
            _rsvp(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double dividerSize = screenWidth > 975 ? screenWidth * 0.35 : screenWidth * 0.2;
    bool mobile = isMobileWidth(context);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: _invitation(context),
        ),
        SizedBox(height: 180 * _spacingScale(context)),
        SquiggleDivider(
          width: screenWidth - dividerSize * 2,
          color: creamColor,
        ),
      ],
    );

    return Container(
      width: screenWidth,
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(
        0,
        (mobile ? 45 : 75) * _spacingScale(context),
        0,
        75 * _spacingScale(context),
      ),
      constraints:
          mobile ? BoxConstraints(minHeight: screenHeight) : const BoxConstraints(),
      child: mobile ? Center(child: content) : content,
    );
  }
}
