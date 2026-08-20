import 'package:flutter/material.dart';

class OverseasGuests extends StatelessWidget {
  const OverseasGuests({super.key});

  static const Color backgroundColor = Color(0xFF687351);
  static const Color creamColor = Color(0xFFF3F0E7);

  bool isDesktopWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  bool isMobileWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  Widget _title(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double titleSize = screenWidth > 975 ? 60.0 : 48.0;

    return Text(
      'For our overseas guests',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Madelyn',
        fontSize: titleSize,
        color: creamColor,
      ),
    );
  }

  Widget _bullet(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 8.0),
            child: Text(
              '•',
              style: TextStyle(color: creamColor, fontSize: fontSize * 1.4),
            ),
          ),
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: fontSize,
                color: creamColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paragraph(String text, double fontSize, {TextAlign? align}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SelectableText(
        text,
        textAlign: align ?? TextAlign.left,
        style: TextStyle(
          fontFamily: 'CoreBandiFace',
          fontSize: fontSize,
          color: creamColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _infoColumn(
    BuildContext context, {
    required String iconAsset,
    required String heading,
    required List<Widget> content,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double headingSize = screenWidth > 975 ? 45.0 : 36.0;
    double iconHeight = screenWidth > 975 ? 110.0 : 50.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            iconAsset,
            height: iconHeight,
            color: creamColor,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            heading,
            style: TextStyle(
              fontFamily: 'Madelyn',
              fontSize: headingSize,
              color: creamColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...content,
      ],
    );
  }

  Widget _accommodationContent(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _paragraph(
          "We've compiled a list of recommended hotels close to our "
          'venues.',
          fontSize,
        ),
        const SizedBox(height: 8),
        _bullet('The Porter House \$\$\$', fontSize),
        _bullet('Meriton Suites \$\$\$', fontSize),
        _bullet('The Sebel \$\$', fontSize),
        _bullet('Ibis \$', fontSize),
        const SizedBox(height: 8),
        _paragraph(
          'Of course, feel free to book wherever you like! We recommend '
          'staying in Sydney CBD, Circular Quay, The Rocks, or Darling '
          'Harbour for easy access to both venues and major attractions.',
          fontSize,
        ),
        _paragraph(
          "Please note that we don't have any links or discounts "
          'available.',
          fontSize,
        ),
      ],
    );
  }

  Widget _thingsToDoContent(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _paragraph(
          "We've compiled a list of some of our favourite things to do "
          "while you're in Sydney!",
          fontSize,
        ),
        const SizedBox(height: 8),
        _bullet(
            'Grab a drink with harbour views at Opera Bar and Squires '
            'Landing',
            fontSize),
        _bullet('Go for a walk through the Botanical Gardens', fontSize),
        _bullet(
            'Grab a banh mi at Marrickville Pork Roll (Darling Square '
            'location)',
            fontSize),
        _bullet('Grab a coffee at Haven', fontSize),
        _bullet(
            'Snack on some pastries at Tenacious Bakehouse or AP Bakery',
            fontSize),
        _bullet('Sip on cocktails at PS40', fontSize),
      ],
    );
  }

  Widget _content(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 975 ? 20.0 : 18.0;

    final gettingAround = _infoColumn(
      context,
      iconAsset: 'assets/images/icon_swans.png',
      heading: 'Getting around',
      content: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Sydney is a very walkable city, especially around the CBD '
              'and harbour areas. Both our ceremony and reception venues '
              'are centrally located, making it easy to move between them '
              'and nearby accommodation.',
              fontSize,
            ),
            _paragraph(
              'There are plenty of public transport options including '
              'train, light rail and bus.',
              fontSize,
            ),
          ],
        ),
      ],
    );

    final accommodation = _infoColumn(
      context,
      iconAsset: 'assets/images/icon_house.png',
      heading: 'Accommodation',
      content: [_accommodationContent(fontSize)],
    );

    final thingsToDo = _infoColumn(
      context,
      iconAsset: 'assets/images/icon_cocktail.png',
      heading: 'Things to do',
      content: [_thingsToDoContent(fontSize)],
    );

    final stack = Column(
      children: [
        gettingAround,
        const SizedBox(height: 50),
        accommodation,
        const SizedBox(height: 65),
        thingsToDo,
      ],
    );

    if (isMobileWidth(context)) return stack;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: stack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth > 975 ? 120 : 50;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding)
          .copyWith(bottom: 60),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Matches the top spacing used above the title on the RSVP,
            // Agenda, and FAQ pages, so the title sits the same distance
            // from the top of the screen across pages.
            SizedBox(height: screenHeight * 0.1),
            _title(context),
            const SizedBox(height: 50),
            _content(context),
          ],
        ),
      ),
    );
  }
}