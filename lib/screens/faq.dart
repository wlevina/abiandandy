import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_website/widgets/app_drawer.dart';
import 'package:wedding_website/widgets/sign_off.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);

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
          "FAQ",
          style: TextStyle(fontFamily: 'Madelyn', fontSize: titleTextSize),
        ),
      ],
    );
  }

  Widget _rsvpDeadlineTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'When is the RSVP deadline?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _rsvpDeadline(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text: 'Please RSVP by December 13th :)',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _whereTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'Where will the ceremony be?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _where(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'The Mint - 10 Macquarie Street, Sydney NSW',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _whereReceptionTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'Where will the reception be?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _whereReception(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text: 'Events by Alpha - The Grand, 238 Castlereagh St, Sydney NSW',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _howGetThereTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'How do I get to the venues?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _howGetThere(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'The Mint and Events by Alpha are both located in Sydney’s CBD and are within walking distance of each other. Both venues are easily accessible by train or bus, and if you’re driving, Wilson Car Park is available at xxx.',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _dressCodeTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'What\'s the dress code?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _dressCode(BuildContext context) {
    //double titleTextSize = screenWidth(context) > 975 ? 28.0 : 24.0;
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'Formal - we would love for you to look your best on the day. Please note that the ceremony will be held outdoors (weather permitting) and is expected to be warm.',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _plusOneTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'Can I bring a guest?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _plusOne(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'We have sent personal invites to each guest that we can accommodate. We hope you understand!',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }
    Widget _kidsTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'Are kids welcome at the wedding?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _kids(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'We love your little ones! However, due to space limitations, we are only able to accommodate children of our overseas guests and those specifically named on the invitation.',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _presentTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'Should I bring a present?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _present(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'A gift is not necessary as we are so grateful to have you travel and spend the day with us. '
                'However, if you would still like to contribute, a wishing well will be available on the day.',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  Widget _moreQuestionsTitle(BuildContext context) {
    double titleTextSize = screenWidth(context) > 975 ? 27.0 : 24.0;

    return SelectableText.rich(
          textAlign: isMobileWidth(context) ? TextAlign.center : TextAlign.left,
          TextSpan(
              text: 'What if I have more questions?',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontWeight: FontWeight.normal,
                fontSize: titleTextSize,
              )),
        );
  }

  Widget _moreQuestions(BuildContext context) {
    double detailsTextSize = screenWidth(context) > 975 ? 20.0 : 18.0;

    return SelectableText.rich(
      textAlign: TextAlign.left,
      TextSpan(children: [
        TextSpan(
            text:
                'Please feel free to contact Andy on (+61) 0416 187 198 or Abi on (+61) 0435 580 856.',
            style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: detailsTextSize, fontWeight: FontWeight.normal)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double contentWidth = 480;
    bool isDesktop = Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux ||
        Theme.of(context).platform == TargetPlatform.macOS;

    double contentWidth = screenWidth > 975
        ? 480
        : (isMobileWidth(context) ? screenWidth - 100 : screenWidth * 0.82);

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
          drawer: const AppDrawer(selectedIndex: 4),
          body: DefaultTextStyle.merge(
              style: const TextStyle(color: Color(0xFFF3F0E7)),
              child: SingleChildScrollView(
                  child: Center(
                      child: Container(
            padding:
                const EdgeInsets.only(left: 50, top: 0, right: 50, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.1),
                _title(context),
                const SizedBox(height: 50),
                _whereTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _where(context)),
                SizedBox(height: screenHeight * 0.08),
                _whereReceptionTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _whereReception(context)),
                SizedBox(height: screenHeight * 0.08),
                _howGetThereTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _howGetThere(context)),
                SizedBox(height: screenHeight * 0.08),
                _rsvpDeadlineTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _rsvpDeadline(context)),
                SizedBox(height: screenHeight * 0.08),
                _dressCodeTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _dressCode(context)),
                SizedBox(height: screenHeight * 0.08),
                _plusOneTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _plusOne(context)),
                SizedBox(height: screenHeight * 0.08),
                _kidsTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _kids(context)),
                SizedBox(height: screenHeight * 0.08),
                _presentTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _present(context)),
                SizedBox(height: screenHeight * .08),
                _moreQuestionsTitle(context),
                const SizedBox(height: 16),
                SizedBox(width: contentWidth, child: _moreQuestions(context)),
                SizedBox(height: screenHeight * .08),
                const SignOff()
              ],
            ),
          )))));
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
        drawer: const AppDrawer(selectedIndex: 4),
        body: DefaultTextStyle.merge(
          style: const TextStyle(color: Color(0xFFF3F0E7)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .1),
                  _title(context),
                  SizedBox(height: screenHeight * .075),
                  _whereTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _where(context)),
                  SizedBox(height: screenHeight * .075),
                  _whereReceptionTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: contentWidth, child: _whereReception(context)),
                  SizedBox(height: screenHeight * .075),
                  _howGetThereTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _howGetThere(context)),
                  SizedBox(height: screenHeight * .075),
                  _rsvpDeadlineTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _rsvpDeadline(context)),
                  SizedBox(height: screenHeight * .075),
                  _dressCodeTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _dressCode(context)),
                  SizedBox(height: screenHeight * .075),
                  _plusOneTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _plusOne(context)),
                  SizedBox(height: screenHeight * .075),
                  _kidsTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _kids(context)),
                  SizedBox(height: screenHeight * .075),
                  _presentTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(width: contentWidth, child: _present(context)),
                  SizedBox(height: screenHeight * .075),
                  _moreQuestionsTitle(context),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: contentWidth, child: _moreQuestions(context)),
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
