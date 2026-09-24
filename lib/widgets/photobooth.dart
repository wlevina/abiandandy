import 'package:flutter/material.dart';
import 'package:wedding_website/widgets/precached_fade_in.dart';

class Photobooth extends StatelessWidget {
  const Photobooth({super.key});

  static const Color backgroundColor = Color(0xFF687351);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gifMaxWidth = screenWidth < 600 ? screenWidth * 0.6 : 480.0;

    return Container(
      color: backgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: gifMaxWidth),
          child: PrecachedFadeIn(
            imagePaths: const ['assets/images/photobooth.gif'],
            child: Image.asset(
              'assets/images/photobooth.gif',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
