import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding_website/widgets/breakpoints.dart';
import 'package:wedding_website/widgets/squiggle_painter.dart';

// Shown in front of the rest of the site until the shared invite password is
// entered. This is a deterrent, not real access control: everything behind
// it still ships in the web bundle, so it only keeps the site off casual
// browsing/search indexing, not anyone willing to open dev tools.
class PasswordGate extends StatefulWidget {
  final Widget child;
  const PasswordGate({super.key, required this.child});

  static const _password = String.fromEnvironment('SITE_PASSWORD');
  static const _prefsKey = 'site_unlocked_v1';

  @override
  State<PasswordGate> createState() => _PasswordGateState();
}

class _PasswordGateState extends State<PasswordGate>
    with TickerProviderStateMixin {
  static const Color backgroundColor = Color.fromRGBO(104, 115, 81, 1);
  static const Color creamColor = Color(0xFFF3F0E7);
  static const Color goldColor = Color(0xFFF4C868);

  // Fade-through timing: the gate fades out over the first 55%, then holds
  // on the plain background until the real site mounts at 75%. The site's
  // own entrance animation (see Introduction) softens its appearance from
  // there — this no longer also ramps its opacity, to avoid stacking two
  // fades on top of each other.
  static const double _gateFadeEnd = 0.55;
  static const double _revealAt = 0.75;

  final _controller = TextEditingController();

  // Null while we're still checking SharedPreferences for a previously
  // unlocked flag, so we don't flash the password screen for returning
  // visitors who already unlocked it.
  bool? _unlocked;
  bool _obscure = true;
  bool _showError = false;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _shakeOffset = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -6, end: 5), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 5, end: -4), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));

  // Drives the fade-through when the password is accepted. Jumped straight
  // to 1 (skipping the animation) for visitors who are already unlocked.
  late final AnimationController _transitionController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    // No password configured at build time (e.g. local `flutter run` without
    // --dart-define=SITE_PASSWORD) — don't lock developers out.
    if (PasswordGate._password.isEmpty) {
      _unlocked = true;
      _transitionController.value = 1;
      return;
    }
    _loadUnlocked();
  }

  Future<void> _loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final unlocked = prefs.getBool(PasswordGate._prefsKey) ?? false;
    if (unlocked) _transitionController.value = 1;
    setState(() => _unlocked = unlocked);
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final entered = _controller.text.trim();
    if (entered.isEmpty) return;

    if (entered.toLowerCase() != PasswordGate._password.trim().toLowerCase()) {
      setState(() => _showError = true);
      _shakeController.forward(from: 0);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PasswordGate._prefsKey, true);
    if (!mounted) return;
    setState(() => _unlocked = true);
    _transitionController.forward(from: 0);
  }

  Widget _field(BuildContext context) {
    const fieldTextStyle = TextStyle(
      fontFamily: 'CoreBandiFace',
      fontSize: 18,
      letterSpacing: 0.5,
    );
    final border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: (_showError ? goldColor : creamColor)
            .withValues(alpha: _showError ? 1 : 0.8),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const ValueKey('password-gate-field'),
          controller: _controller,
          obscureText: _obscure,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          onChanged: (_) {
            if (_showError) setState(() => _showError = false);
          },
          style: fieldTextStyle.copyWith(color: creamColor),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: fieldTextStyle.copyWith(
              color: creamColor.withValues(alpha: 0.42),
            ),
            enabledBorder: border,
            focusedBorder: border,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: TextButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                style: TextButton.styleFrom(
                  foregroundColor: creamColor.withValues(alpha: 0.68),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: TextStyle(
                    fontFamily: 'CoreBandiFace',
                    fontSize: isMobileWidth(context) ? 12 : 13,
                    letterSpacing: 1,
                  ),
                ),
                child: Text(_obscure ? 'SHOW' : 'HIDE'),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.topLeft,
          child: _showError
              ? Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Text(
                    "That's not quite right — check your invite and try again.",
                    style: TextStyle(
                      fontFamily: 'CoreBandiFace',
                      fontSize: isMobileWidth(context) ? 14 : 15,
                      color: goldColor,
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget _gate(BuildContext context) {
    bool mobile = isMobileWidth(context);
    final contactFontSize = mobile ? 12.0 : 13.0;

    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'A & A',
            style: TextStyle(
              fontFamily: 'Madelyn',
              // Matches the "A & A" sign-off at the bottom of the real site
              // (lib/widgets/sign_off.dart) so the two read as the same mark.
              fontSize: mobile ? 50 : 65,
              color: creamColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '13 MARCH 2027 · SYDNEY, AUSTRALIA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'CoreBandiFace',
              fontSize: mobile ? 16 : 20,
              letterSpacing: 1.5,
              color: creamColor,
            ),
          ),
          const SizedBox(height: 18),
          const SquiggleDivider(width: 90, height: 14, color: creamColor),
          const SizedBox(height: 30),
          AnimatedBuilder(
            animation: _shakeOffset,
            builder: (context, child) => Transform.translate(
              offset: Offset(_shakeOffset.value, 0),
              child: child,
            ),
            child: SizedBox(width: 280, child: _field(context)),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: creamColor,
              foregroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 32 : 36,
                vertical: 12,
              ),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              elevation: 0,
            ),
            child: Text(
              'Enter',
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: mobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text.rich(
            TextSpan(
              text: "Can't find your password? ",
              style: TextStyle(
                fontFamily: 'CoreBandiFace',
                fontSize: contactFontSize,
                color: creamColor.withValues(alpha: 0.42),
              ),
              children: [
                TextSpan(
                  text: 'Contact us directly.',
                  style: TextStyle(
                    fontFamily: 'CoreBandiFace',
                    fontSize: contactFontSize,
                    color: creamColor.withValues(alpha: 0.68),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            // 50px horizontal matches the FAQ/Wedding Agenda/RSVP screens.
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(alignment: const Alignment(0, -0.3), child: content),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked == null) {
      // Still checking SharedPreferences — plain background, no flash of
      // either the gate or the real site.
      return const ColoredBox(color: backgroundColor);
    }

    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        final t = _transitionController.value;

        // Reveal point reached — mount the real site and let its own
        // entrance animation (Introduction's fade + rise) take it from
        // here, with no leftover Opacity/Stack wrapper around it.
        if (t >= _revealAt) return widget.child;

        final gateOpacity = (1 - t / _gateFadeEnd).clamp(0.0, 1.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: backgroundColor),
            if (gateOpacity > 0)
              Opacity(opacity: gateOpacity, child: _gate(context)),
          ],
        );
      },
    );
  }
}
