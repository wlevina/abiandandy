import 'package:flutter/material.dart';

// Hand-drawn-style squiggle used both as a small underline accent and,
// stretched wide, as the wavy divider between page sections.
class SquigglePainter extends CustomPainter {
  final Color color;

  SquigglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.15, 0, size.width * 0.3, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.6, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.75, 0, size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SquigglePainter oldDelegate) =>
      oldDelegate.color != color;
}

// Convenience widget for a squiggle divider spanning `width`, replacing a
// plain Divider between sections.
class SquiggleDivider extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const SquiggleDivider({
    super.key,
    required this.width,
    required this.color,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: SquigglePainter(color: color)),
    );
  }
}
