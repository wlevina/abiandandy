import 'package:flutter/material.dart';
import 'package:wedding_website/screens/rsvp_form.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/breakpoints.dart';
import 'package:wedding_website/widgets/spacing.dart';
import 'package:wedding_website/widgets/squiggle_painter.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction>
    with SingleTickerProviderStateMixin {
  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);

  // Starts once both hero images are precached (see didChangeDependencies)
  // so the images and text settle in together, instead of the images
  // sometimes popping in a beat after the animation has already finished.
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  // easeIn so opacity climbs for the whole duration rather than popping early;
  // the slide keeps easeOut, the natural curve for settling into place.
  late final Animation<double> _entranceOpacity =
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn);
  late final Animation<double> _entranceSlide =
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);

  bool _precacheRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage needs the inherited asset bundle/MediaQuery, which isn't
    // reliably available in initState, so kick it off here — guarded so it
    // only fires once per widget lifetime.
    if (_precacheRequested) return;
    _precacheRequested = true;
    Future.wait([
      precacheImage(
          const AssetImage('assets/images/abi_and_andy_title.png'), context),
      precacheImage(
          const AssetImage('assets/images/champagne_home.png'), context),
    ]).then((_) {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // Width where hand-tuned phone values (e.g. 350 title, 180 image) apply exactly; below it, sizing stays flat.
  static const double _phoneReferenceWidth = 390;

  // Ramps from phoneValue to desktopValue as width grows from 390px to mobileBreakpoint,
  // so tablet widths get an in-between size instead of jumping straight from one to the other.
  double _scaleWidth(
      BuildContext context, double phoneValue, double desktopValue) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= mobileBreakpoint) return desktopValue;
    double t = ((screenWidth - _phoneReferenceWidth) /
            (mobileBreakpoint - _phoneReferenceWidth))
        .clamp(0.0, 1.0);
    return phoneValue + (desktopValue - phoneValue) * t;
  }

  // Whitespace is cheap to cut, so it shrinks hard first (clamped 0.68-1.0) on short viewports,
  // while title/images/text only shrink a little — section fits without looking shrunken.
  double _contentScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / 1312.5).clamp(0.68, 1.0);
  }

  // Text barely affects the vertical budget vs. the title/champagne images, so it keeps
  // a higher floor (0.85-1.0 desktop, 1.0-1.15 mobile) without bringing back RSVP overflow.
  double _textScale(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double scale = screenHeight / 1312.5;
    return isMobileWidth(context) ? scale.clamp(1.0, 1.15) : scale.clamp(0.85, 1.0);
  }

  // Small hand-drawn-style squiggle used under the date/location text.
  Widget _squiggle({double width = 90}) {
    return SquiggleDivider(width: width, height: 14, color: creamColor);
  }

  // Real asset is 4269x2194 — explicit height reserves the right box before
  // decode, so layout doesn't jump once the image loads.
  static const double _titleAspectRatio = 4269 / 2194;

  Widget _title(BuildContext context) {
    double titleWidth =
        _scaleWidth(context, 350.0, 825.0) * _contentScale(context);

    return Image.asset(
      'assets/images/abi_and_andy_title.png',
      width: titleWidth,
      height: titleWidth / _titleAspectRatio,
      fit: BoxFit.contain,
    );
  }

  Widget _detailsRow(BuildContext context) {
    double scale = spacingScale(context);
    double labelSize = _scaleWidth(context, 18.0, 22.5) * _textScale(context);
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
        const SizedBox(height: 6),
        _squiggle(),
      ],
    );

    final locationColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('SYDNEY, AUSTRALIA', style: textStyle),
        const SizedBox(height: 6),
        _squiggle(),
      ],
    );

    if (isMobileWidth(context)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dateColumn,
          SizedBox(height: 20 * scale),
          _centerImage(context),
          SizedBox(height: 20 * scale),
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

  // Real asset is 769x800 — see _titleAspectRatio for why this is explicit.
  static const double _champagneAspectRatio = 769 / 800;

  Widget _centerImage(BuildContext context) {
    double imageWidth =
        _scaleWidth(context, 180.0, 325.0) * _contentScale(context);

    return Image.asset(
      'assets/images/champagne_home.png',
      width: imageWidth,
      height: imageWidth / _champagneAspectRatio,
      fit: BoxFit.contain,
    );
  }

  Widget _inviteLine(BuildContext context) {
    double fontSize = _scaleWidth(context, 16.0, 20.0) * _textScale(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'WE CAN\'T WAIT TO CELEBRATE WITH YOU',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontFamily: 'CoreBandiFace',
          fontSize: fontSize,
          color: creamColor,
          letterSpacing: 1.2,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _countDown(BuildContext context) {
    double countdownSize =
        _scaleWidth(context, 16.5, 22.5) * _textScale(context);

    final dday = DateTime.utc(2027, 3, 13);
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final difference = dday.difference(today).inDays;

    var ddayText = difference > 0
        ? '$difference DAYS TO GO!'
        : difference == 0
            ? "IT'S TODAY!"
            : '';

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
    double textScale = _textScale(context);
    double rsvpTextSize = _scaleWidth(context, 24.0, 25.0) * textScale;

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

  Widget _rsvpNote(BuildContext context) {
    double fontSize = _scaleWidth(context, 14.0, 18.0) * _textScale(context);

    return Text(
      "Kindly RSVP by December 13",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'CoreBandiFace',
        fontSize: fontSize,
        color: creamColor,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _invitation(BuildContext context) {
    double scale = spacingScale(context);
    double horizontalPadding = _scaleWidth(context, 24.0, 75.0);
    double wideWidth =
        _scaleWidth(context, 500.0, 1250.0) * _contentScale(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: wideWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(context),
            _detailsRow(context),
            SizedBox(height: 60 * scale),
            _inviteLine(context),
            SizedBox(height: 44 * scale),
            _countDown(context),
            SizedBox(height: 56 * scale),
            _rsvp(context),
            SizedBox(height: 25 * scale),
            _rsvpNote(context),
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
        SizedBox(height: 220 * spacingScale(context)),
        SquiggleDivider(
          width: screenWidth - dividerSize * 2,
          color: creamColor,
        ),
      ],
    );

    // ClipRect because SlideTransition doesn't clip — without it the offset
    // start position bleeds into the section below for the first frames.
    Widget animatedContent = ClipRect(
      child: FadeTransition(
        opacity: _entranceOpacity,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(_entranceSlide),
          child: content,
        ),
      ),
    );

    return Container(
      width: screenWidth,
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(
        0,
        (mobile ? 1 : 35) * spacingScale(context),
        0,
        75 * spacingScale(context),
      ),
      constraints:
          mobile ? BoxConstraints(minHeight: screenHeight) : const BoxConstraints(),
      child: mobile
          ? Align(alignment: Alignment.bottomCenter, child: animatedContent)
          : animatedContent,
    );
  }
}
