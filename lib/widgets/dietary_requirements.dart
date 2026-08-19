import 'package:flutter/material.dart';

class DietaryRequirements extends StatelessWidget {
  const DietaryRequirements({
    super.key,
    required this.controllerDietary,
    required this.context,
  });

  final TextEditingController controllerDietary;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldTextSize = screenWidth > 975 ? 18.0 : 18.0;
    double hintTextSize = screenWidth > 975 ? 15.0 : 16.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Please let us know if you have any dietary requirements",
          style: TextStyle(fontFamily: 'CoreBandiFace', fontSize: fieldTextSize),
        ),
        TextField(
          style: TextStyle(fontFamily: 'CoreBandiFace', fontSize: fieldTextSize),
          onChanged: (value) {},
          controller: controllerDietary,
          decoration: InputDecoration(
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            hintStyle: TextStyle(fontFamily: 'CoreBandiFace', fontSize: hintTextSize),
            hintText: "e.g. Vegetarian, allergic to nutz", //form validate name?
          ),
        ),
      ],
    );
  }
}
