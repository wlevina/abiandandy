import 'package:flutter/material.dart';

// Scales vertical spacing against a reference viewport height (1625px) so
// gaps shrink proportionally on shorter screens instead of overflowing,
// but never grow past their base size on taller ones.
double spacingScale(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  return (screenHeight / 1625).clamp(0.4, 1.0);
}
