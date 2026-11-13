import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/pro9_theme.dart';

/// Renders the exact Master Template outro HUD overlay matching reference coordinates:
/// - Upper HUD Box: Left-aligned at X=185, Y=310, fontSize: 42, letterSpacing: 6.0
/// - Lower HUD Box: Left-aligned at X=185, Y=535, fontSize: 34, letterSpacing: 2.0, height: 1.45
/// - Montserrat Bold with vertical linear gradient (#78F6FF to #1296FF)
/// - Outer neon blue glow (#006AFF)
/// - Typewriter animations:
///   * Monitor Code: starts at 4.40s, duration 0.3s (until 4.70s)
///   * Description: starts at 5.00s, duration 0.9s (until 5.90s)
class Pro9OutroOverlayWidget extends StatefulWidget {
  final String monitorCode;
  final String caseName;
  final String incidentTime;
  final String incidentDetails;
  final bool animate;

  const Pro9OutroOverlayWidget({
    super.key,
    required this.monitorCode,
    required this.caseName,
    required this.incidentTime,
    required this.incidentDetails,
    this.animate = true,
  });

  @override
  State<Pro9OutroOverlayWidget> createState() => _Pro9OutroOverlayWidgetState();
}

class _Pro9OutroOverlayWidgetState extends State<Pro9OutroOverlayWidget> {
  String _monitorVisible = '';
  String _descVisible = '';
  Timer? _monitorTimer;
  Timer? _descTimer;

  // Clean strings (NO '>' prefix!)
  String get _fullMonitor => widget.monitorCode.trim().toUpperCase();
  String get _fullDesc =>
      'Case: ${widget.caseName.trim()}\n'
      'Time: ${widget.incidentTime.trim()}\n'
      'Note: ${widget.incidentDetails.trim()}';

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _startAnimations();
    } else {
      _monitorVisible = _fullMonitor;
      _descVisible = _fullDesc;
    }
  }

  @override
  void didUpdateWidget(covariant Pro9OutroOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monitorCode != widget.monitorCode ||
        oldWidget.caseName != widget.caseName ||
        oldWidget.incidentTime != widget.incidentTime ||
        oldWidget.incidentDetails != widget.incidentDetails) {
      _cancelTimers();
      if (widget.animate) {
        _startAnimations();
      } else {
        setState(() {
          _monitorVisible = _fullMonitor;
          _descVisible = _fullDesc;
        });
      }
    }
  }

  void _startAnimations() {
    _monitorVisible = '';
    _descVisible = '';

    // Monitor code: starts at 4.40s, duration 0.30s (300ms)
    final monitorText = _fullMonitor;
    if (monitorText.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 4400), () {
        if (!mounted) return;
        final charDelay =
            Duration(milliseconds: (300 ~/ monitorText.length).clamp(15, 100));
        int charIndex = 0;
        _monitorTimer = Timer.periodic(charDelay, (timer) {
          if (charIndex < monitorText.length) {
            setState(() {
              _monitorVisible = monitorText.substring(0, charIndex + 1);
            });
            charIndex++;
          } else {
            timer.cancel();
          }
        });
      });
    }

    // Description: starts at 5.00s, duration 0.90s (900ms)
    final descText = _fullDesc;
    if (descText.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        if (!mounted) return;
        final charDelay =
            Duration(milliseconds: (900 ~/ descText.length).clamp(8, 60));
        int charIndex = 0;
        _descTimer = Timer.periodic(charDelay, (timer) {
          if (charIndex < descText.length) {
            setState(() {
              _descVisible = descText.substring(0, charIndex + 1);
            });
            charIndex++;
          } else {
            timer.cancel();
          }
        });
      });
    }
  }

  void _cancelTimers() {
    _monitorTimer?.cancel();
    _descTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Scaled to match exact 1920x1080 canvas coordinates
        final scale = constraints.maxWidth / 1920.0;

        final upperLeft = 185.0 * scale;
        final upperTop = 310.0 * scale;
        final upperFontSize = 42.0 * scale;
        final upperSpacing = 6.0 * scale;

        final lowerLeft = 185.0 * scale;
        final lowerTop = 535.0 * scale;
        final lowerFontSize = 34.0 * scale;
        final lowerSpacing = 2.0 * scale;
        final lowerMaxWidth = 1520.0 * scale;

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Upper HUD Box: Left-aligned at (185, 310) ──────────────
            if (_monitorVisible.isNotEmpty)
              Positioned(
                left: upperLeft,
                top: upperTop,
                child: _GlowGradientText(
                  text: _monitorVisible,
                  fontSize: upperFontSize,
                  letterSpacing: upperSpacing,
                  textAlign: TextAlign.left,
                ),
              ),

            // ── Lower HUD Box: Left-aligned & Top-aligned at (185, 535) ─
            if (_descVisible.isNotEmpty)
              Positioned(
                left: lowerLeft,
                top: lowerTop,
                width: lowerMaxWidth,
                child: _GlowGradientText(
                  text: _descVisible,
                  fontSize: lowerFontSize,
                  letterSpacing: lowerSpacing,
                  lineHeight: 1.45,
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Text widget with vertical gradient fill + outer neon blue glow.
class _GlowGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double letterSpacing;
  final double lineHeight;
  final TextAlign textAlign;

  const _GlowGradientText({
    required this.text,
    required this.fontSize,
    this.letterSpacing = 0,
    this.lineHeight = 1.0,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    final textStyle = GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: lineHeight,
      color: Colors.white,
    );

    return Stack(
      children: [
        // Outer glow layer
        Text(
          text,
          textAlign: textAlign,
          style: textStyle.copyWith(
            foreground: Paint()
              ..color = Pro9Theme.glowBlue.withValues(alpha: 0.0),
            shadows: [
              Shadow(
                color: Pro9Theme.glowBlue.withValues(alpha: 0.9),
                blurRadius: 16,
              ),
              Shadow(
                color: Pro9Theme.glowBlue.withValues(alpha: 0.7),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        // Gradient fill via ShaderMask
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Pro9Theme.gradientTop, // #78F6FF
              Pro9Theme.gradientBottom, // #1296FF
            ],
          ).createShader(bounds),
          child: Text(
            text,
            textAlign: textAlign,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
