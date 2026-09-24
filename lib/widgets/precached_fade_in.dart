import 'package:flutter/material.dart';

// On Flutter web, Image.asset fetches bytes over HTTP after first paint, so
// an image can visibly pop in after its surrounding text has already
// rendered. This waits for [imagePaths] to finish decoding before revealing
// [child], then fades it in as one unit so image and text always appear
// together.
class PrecachedFadeIn extends StatefulWidget {
  final List<String> imagePaths;
  final Widget child;
  final Duration duration;

  const PrecachedFadeIn({
    super.key,
    required this.imagePaths,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  State<PrecachedFadeIn> createState() => _PrecachedFadeInState();
}

class _PrecachedFadeInState extends State<PrecachedFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _opacity =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage needs an inherited MediaQuery/asset bundle, which isn't
    // reliably available yet in initState, so kick it off here instead —
    // guarded so it only runs once per widget lifetime.
    if (_requested) return;
    _requested = true;
    Future.wait([
      for (final path in widget.imagePaths)
        precacheImage(AssetImage(path), context),
    ]).then((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}
