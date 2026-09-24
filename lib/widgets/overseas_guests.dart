import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_website/widgets/breakpoints.dart';
import 'package:wedding_website/widgets/precached_fade_in.dart';

class OverseasGuests extends StatelessWidget {
  const OverseasGuests({super.key});

  static const Color backgroundColor = Color(0xFF687351);
  static const Color creamColor = Color(0xFFF3F0E7);

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

  Widget _bullet(String text, double fontSize,
      {String? boldPrefix, Map<String, String>? links}) {
    final baseStyle = TextStyle(
      fontFamily: 'CoreBandiFace',
      fontSize: fontSize,
      color: creamColor,
      height: 1.5,
    );

    String remaining = text;
    final spans = <InlineSpan>[];

    if (boldPrefix != null) {
      spans.add(TextSpan(
        text: boldPrefix,
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ));
      remaining = remaining.substring(boldPrefix.length);
    }

    if (links != null && links.isNotEmpty) {
      final matches = <MapEntry<int, String>>[];
      for (final key in links.keys) {
        final idx = remaining.indexOf(key);
        if (idx != -1) matches.add(MapEntry(idx, key));
      }
      matches.sort((a, b) => a.key.compareTo(b.key));

      int cursor = 0;
      for (final match in matches) {
        if (match.key < cursor) continue;
        if (match.key > cursor) {
          spans.add(TextSpan(text: remaining.substring(cursor, match.key)));
        }
        final linkUrl = links[match.value]!;
        spans.add(TextSpan(
          text: match.value,
          style: const TextStyle(decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(
                  Uri.parse(linkUrl),
                  mode: LaunchMode.externalApplication,
                  webOnlyWindowName: isMobileBrowser ? '_self' : null,
                ),
        ));
        cursor = match.key + match.value.length;
      }
      if (cursor < remaining.length) {
        spans.add(TextSpan(text: remaining.substring(cursor)));
      }
    } else {
      spans.add(TextSpan(text: remaining));
    }

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
            child: Text.rich(
              TextSpan(children: spans, style: baseStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paragraph(String text, double fontSize,
      {TextAlign? align, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textAlign: align ?? TextAlign.left,
        style: TextStyle(
          fontFamily: 'CoreBandiFace',
          fontSize: fontSize,
          color: creamColor,
          height: 1.5,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
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
    double headingSize = screenWidth > 975 ? 30.0 : 24.0;
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
              fontFamily: 'CoreBandiFace',
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
        _bullet(
            'Sofitel Sydney Darling Harbour \$\$\$\$ — modern upscale hotel in Darling Harbour. High level rooms can include harbour and city views',
            fontSize,
            boldPrefix: 'Sofitel Sydney Darling Harbour \$\$\$\$'),
        _bullet(
            'Meriton Suites \$\$\$ — spacious apartment-style rooms, great if you want more space or are staying a few nights',
            fontSize,
            boldPrefix: 'Meriton Suites \$\$\$'),
        _bullet(
            'The Sebel \$\$ — comfortable mid-range option, well located for both venues',
            fontSize,
            boldPrefix: 'The Sebel \$\$'),
        _bullet('Ibis \$ — simple and budget-friendly', fontSize,
            boldPrefix: 'Ibis \$'),
        const SizedBox(height: 8),
        _paragraph(
          'Of course, feel free to book wherever you like! We recommend '
          'staying in Sydney CBD, Circular Quay, The Rocks, or Darling '
          'Harbour for easy access to both venues and major attractions.',
          fontSize,
        ),
        _paragraph(
          "We haven't arranged a room block, so just book directly through your preferred site. ",
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
          "While you're in town, here are some of our favourite spots in Sydney! If you’d like more local tips and recommendations, please feel free to reach out to us directly. ",
          fontSize,
        ),
        const SizedBox(height: 16),
        _paragraph(
          "Eat & Drink",
          fontSize,
          bold: true,
        ),
        const SizedBox(height: 8),
        _bullet(
            'Enjoy harbour views over a drink at Opera Bar or Cruise Bar',
            fontSize,
            links: {
              'Opera Bar':
                  'https://www.google.com/maps/search/?api=1&query=Opera+Bar+Sydney&query_place_id=ChIJB5NuYGauEmsROhQEpJXe5qo',
              'Cruise Bar': 'https://maps.app.goo.gl/fPa8oSY2Hr63Grjd7',
            }),
        _bullet('Pick up a banh mi at Marrickville Pork Roll — Darling Square',
            fontSize,
            links: {
              'Marrickville Pork Roll — Darling Square':
                  'https://www.google.com/maps/search/?api=1&query=Marrickville+Pork+Roll+Sydney&query_place_id=ChIJJaaNZW2vEmsRkr5f5mOgNjQ',
            }),
        _bullet('Stop for coffee at Haven or Stitch Coffee QVB', fontSize,
            links: {
              'Haven':
                  'https://www.google.com/maps/search/?api=1&query=Haven+Coffee+Sydney&query_place_id=ChIJsz7gdjmvEmsRp8ZOyC6med0',
              'Stitch Coffee QVB': 'https://maps.app.goo.gl/g5CyyqiYqctLfFRt9',
            }),
        _bullet(
            'Snack on pastries at Tenacious Bakehouse or AP Bakery', fontSize,
            links: {
              'Tenacious Bakehouse':
                  'https://www.google.com/maps/search/?api=1&query=Tenacious+Bakehouse+Sydney&query_place_id=ChIJi_M0Jg2vEmsRe5F0CLYnBJk',
              'AP Bakery':
                  'https://www.google.com/maps/search/?api=1&query=AP+Bakery+Sydney&query_place_id=ChIJhZn8INevEmsRf8uU48OObm0',
            }),
        _bullet('Grab a scoop at Gelato Messina', fontSize, links: {
          'Gelato Messina':
              'https://www.google.com/maps/search/?api=1&query=Gelato+Messina+Circular+Quay&query_place_id=ChIJlyAUd0KuEmsRUUgk0FiWG14',
        }),
        _bullet('Sip on cocktails at Untied, PS40 or Maybe Sammy', fontSize,
            links: {
              'Untied': 'https://maps.app.goo.gl/QqKtCSAgNF4PMrjq5',
          'PS40':
              'https://www.google.com/maps/search/?api=1&query=PS40+Sydney&query_place_id=ChIJqcU0ST-uEmsRClU9RTRiAk4',
          'Maybe Sammy': 'https://maps.app.goo.gl/e5wXquuB5oK38suV8',
        }),
        _bullet(
            'Browse fresh seafood and grab a bite at the Sydney Fish Market',
            fontSize,
            links: {
              'Sydney Fish Market':
                  'https://www.google.com/maps/search/?api=1&query=Sydney+Fish+Market&query_place_id=ChIJqy_-dTGuEmsRtBGe8eEFI8E',
            }),
        const SizedBox(height: 16),
        _paragraph(
          "See & Do",
          fontSize,
          bold: true,
        ),
        _bullet('Go for a walk through the Royal Botanical Gardens', fontSize,
            links: {
              'Royal Botanical Gardens':
                  'https://www.google.com/maps/search/?api=1&query=Royal+Botanic+Garden+Sydney&query_place_id=ChIJWaTdYGuuEmsRoOfx-Wh9AQ8',
            }),
        _bullet(
            'Take in the Sydney Opera House and Sydney Harbour Bridge — even just walking around Circular Quay and along Sydney Harbour is worth the trip',
            fontSize,
            links: {
              'Sydney Opera House':
                  'https://www.google.com/maps/search/?api=1&query=Sydney+Opera+House&query_place_id=ChIJ3S-JXmauEmsRUcIaWtf4MzE',
              'Sydney Harbour Bridge':
                  'https://www.google.com/maps/search/?api=1&query=Sydney+Harbour+Bridge&query_place_id=ChIJ49XqJV2uEmsRPsTAF7eOlGg',
            }),
        _bullet('Go for a dip at Bondi Beach or Coogee Beach', fontSize,
            links: {
              'Bondi Beach':
                  'https://www.google.com/maps/search/?api=1&query=Bondi+Beach+Sydney&query_place_id=ChIJx4FyRJytEmsReOktxgkYwyA',
              'Coogee Beach':
                  'https://www.google.com/maps/search/?api=1&query=Coogee+Sydney&query_place_id=ChIJ4ZOCY5yxEmsR4LIyFmh9AQU',
            }),
        _bullet(
            'Take the ferry from Circular Quay to Manly Beach for a beachy day trip',
            fontSize,
            links: {
              'Circular Quay': 'https://maps.app.goo.gl/4vRbh8rqW3okQ23V9',
              'Manly Beach': 'https://maps.app.goo.gl/qu43HCr2XAC1EmTH6',
            }),
        _bullet('Visit Taronga Zoo to see all the unique Australian wildlife',
            fontSize,
            links: {
              'Taronga Zoo': 'https://maps.app.goo.gl/A9WnhPhoH6jDb8ZZ7',
            }),

      ],
    );
  }

  Widget _content(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 975 ? 20.0 : 18.0;

    final gettingAround = _infoColumn(
      context,
      iconAsset: 'assets/images/icon_swans.png',
      heading: 'Getting Around',
      content: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _paragraph(
              'Sydney is a very walkable city, especially around the CBD '
              'and harbour — and both our venues are right in the middle of the CBD. ',
              fontSize,
            ),
            const SizedBox(height: 8),
            _bullet(
                'Between the ceremony and reception: The Mint and Events by Alpha are about a 10-minute walk apart. If you\'d rather not walk in your formal wear, taxis and Ubers are readily available. ',
                fontSize,
                boldPrefix: 'Between the ceremony and reception:'),
            _bullet(
                'Public transport: Sydney\'s trains, light rail and buses all run on the Opal card system — you can simply tap on with a contactless Visa or Mastercard, or a linked phone/watch (just be aware your bank may charge international transaction fees). You can also purchase a physical Opal card if you\'d prefer.',
                fontSize,
                boldPrefix: 'Public transport:'),
            _bullet(
                'Taxis & rideshare: Taxis and Ubers operate widely across the city.',
                fontSize,
                boldPrefix: 'Taxis & rideshare:'),
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
      heading: 'Things To Do',
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
        child: SelectionArea(
          child: Column(
            children: [
              // Matches the top spacing used above the title on the RSVP,
              // Agenda, and FAQ pages, so the title sits the same distance
              // from the top of the screen across pages.
              SizedBox(height: screenHeight * 0.1),
              _title(context),
              const SizedBox(height: 50),
              PrecachedFadeIn(
                imagePaths: const [
                  'assets/images/icon_swans.png',
                  'assets/images/icon_house.png',
                  'assets/images/icon_cocktail.png',
                ],
                child: _content(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}