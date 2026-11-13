import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Pure Flutter Offscreen Canvas Frame Generator.
///
/// Uses [ui.PictureRecorder], [Canvas], and [TextPainter] to render transparent
/// 1920x1080 PNG frames for the animated Outro HUD overlay with:
/// - Exact coordinates: Upper (X=185, Y=310), Lower (X=185, Y=535)
/// - Left-alignment (no centering)
/// - Vertical linear gradient fill (#78F6FF to #1296FF)
/// - Outer neon blue glow (#006AFF)
/// - Typewriter animations:
///   * Monitor Code: starts at 4.40s, duration 0.3s (until 4.70s)
///   * Description: starts at 5.00s, duration 0.9s (until 5.90s)
///   * Holds static until the end of the video.
class OutroOverlayGenerator {
  OutroOverlayGenerator._();

  static const double canvasWidth = 1920.0;
  static const double canvasHeight = 1080.0;

  // Exact coordinates
  static const double upperX = 185.0;
  static const double upperY = 310.0;
  static const double lowerX = 185.0;
  static const double lowerY = 535.0;
  static const double maxWidth = 1520.0;

  // Typography specs
  static const double upperFontSize = 42.0;
  static const double upperLetterSpacing = 6.0;

  static const double lowerFontSize = 34.0;
  static const double lowerLetterSpacing = 2.0;
  static const double lowerLineHeight = 1.45;

  // Colors
  static const Color cyanTop = Color(0xFF78F6FF);
  static const Color blueBottom = Color(0xFF1296FF);
  static const Color glowBlue = Color(0xFF006AFF);

  /// Generates all 1920x1080 transparent PNG frames named `frame_0001.png` .. `frame_0240.png`
  /// into [outputDir] at [fps] (default 30 fps for [totalDurationSeconds] = 8.0s).
  static Future<void> generateFrames({
    required Directory outputDir,
    required String monitorCode,
    required String caseName,
    required String incidentTime,
    required String incidentDetails,
    int fps = 30,
    double totalDurationSeconds = 8.0,
  }) async {
    await outputDir.create(recursive: true);

    final totalFrames = (totalDurationSeconds * fps).round();

    // Clean strings (NO '>' prefix!)
    final fullUpper = monitorCode.trim().toUpperCase();
    final fullLower = 'Case: ${caseName.trim()}\n'
        'Time: ${incidentTime.trim()}\n'
        'Note: ${incidentDetails.trim()}';

    // Typewriter timing (in seconds)
    const monitorStart = 4.40;
    const monitorDuration = 0.30;
    const monitorEnd = monitorStart + monitorDuration; // 4.70

    const descStart = 5.00;
    const descDuration = 0.90;
    const descEnd = descStart + descDuration; // 5.90

    const fontName = 'Montserrat';
    const fallbackFonts = ['Segoe UI', 'Arial', 'sans-serif'];

    // ── Pre-render 1 blank transparent PNG for all frames before 4.40s ──
    final blankBytes = await _renderFrameToPng(
      upperText: '',
      lowerText: '',
      fontName: fontName,
      fallbackFonts: fallbackFonts,
    );

    // ── Pre-render 1 static full PNG for all frames after 5.90s ─────────
    final fullBytes = await _renderFrameToPng(
      upperText: fullUpper,
      lowerText: fullLower,
      fontName: fontName,
      fallbackFonts: fallbackFonts,
    );

    // Render / write all frames
    for (int frameIdx = 0; frameIdx < totalFrames; frameIdx++) {
      final t = frameIdx / fps;
      final fileNum = (frameIdx + 1).toString().padLeft(4, '0');
      final framePath = '${outputDir.path}${Platform.pathSeparator}frame_$fileNum.png';

      if (t < monitorStart) {
        // Frame before typewriter starts: blank
        await File(framePath).writeAsBytes(blankBytes, flush: false);
      } else if (t >= descEnd) {
        // Frame after all typewriter animations complete: full static
        await File(framePath).writeAsBytes(fullBytes, flush: false);
      } else {
        // Active typewriter animation window: calculate visible characters
        String visibleUpper = '';
        if (t >= monitorEnd) {
          visibleUpper = fullUpper;
        } else if (t >= monitorStart) {
          final frac = (t - monitorStart) / monitorDuration;
          final count = (frac * fullUpper.length).ceil().clamp(1, fullUpper.length);
          visibleUpper = fullUpper.substring(0, count);
        }

        String visibleLower = '';
        if (t >= descEnd) {
          visibleLower = fullLower;
        } else if (t >= descStart) {
          final frac = (t - descStart) / descDuration;
          final count = (frac * fullLower.length).ceil().clamp(1, fullLower.length);
          visibleLower = fullLower.substring(0, count);
        }

        final dynamicBytes = await _renderFrameToPng(
          upperText: visibleUpper,
          lowerText: visibleLower,
          fontName: fontName,
          fallbackFonts: fallbackFonts,
        );
        await File(framePath).writeAsBytes(dynamicBytes, flush: false);
      }
    }
  }

  /// Renders a single 1920x1080 transparent overlay frame with exact gradient & glow.
  static Future<List<int>> _renderFrameToPng({
    required String upperText,
    required String lowerText,
    required String? fontName,
    required List<String> fallbackFonts,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      const Rect.fromLTWH(0, 0, canvasWidth, canvasHeight),
    );

    // Clear transparent background
    canvas.drawColor(Colors.transparent, BlendMode.clear);

    // ── Upper Box: Left-aligned at (185, 310) ──────────────────────────────
    if (upperText.isNotEmpty) {
      _paintGlowAndGradientText(
        canvas: canvas,
        text: upperText,
        x: upperX,
        y: upperY,
        fontSize: upperFontSize,
        letterSpacing: upperLetterSpacing,
        fontName: fontName,
        fallbackFonts: fallbackFonts,
      );
    }

    // ── Lower Box: Left-aligned & Top-aligned at (185, 535) ────────────────
    if (lowerText.isNotEmpty) {
      _paintGlowAndGradientText(
        canvas: canvas,
        text: lowerText,
        x: lowerX,
        y: lowerY,
        fontSize: lowerFontSize,
        letterSpacing: lowerLetterSpacing,
        height: lowerLineHeight,
        maxWidth: maxWidth,
        fontName: fontName,
        fallbackFonts: fallbackFonts,
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();

    return byteData!.buffer.asUint8List();
  }

  /// Paints text with 2-pass rendering: outer neon blue glow (#006AFF) + vertical gradient (#78F6FF -> #1296FF).
  static void _paintGlowAndGradientText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required double fontSize,
    required double letterSpacing,
    double height = 1.0,
    double maxWidth = maxWidth,
    required String? fontName,
    required List<String> fallbackFonts,
  }) {
    // Pass 1: Outer Neon Blue Glow (#006AFF with 16px and 6px blur)
    final glowStyle = TextStyle(
      fontFamily: fontName,
      fontFamilyFallback: fallbackFonts,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: height,
      color: glowBlue,
      shadows: const [
        Shadow(color: glowBlue, blurRadius: 16),
        Shadow(color: glowBlue, blurRadius: 6),
      ],
    );

    final glowPainter = TextPainter(
      text: TextSpan(text: text, style: glowStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    glowPainter.paint(canvas, Offset(x, y));

    // Pass 2: Vertical Linear Gradient (#78F6FF top -> #1296FF bottom)
    final textH = glowPainter.height > 0 ? glowPainter.height : fontSize;
    final gradientShader = ui.Gradient.linear(
      Offset(x, y),
      Offset(x, y + textH),
      const [cyanTop, blueBottom],
    );

    final gradientStyle = TextStyle(
      fontFamily: fontName,
      fontFamilyFallback: fallbackFonts,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: letterSpacing,
      height: height,
      foreground: Paint()..shader = gradientShader,
    );

    final gradientPainter = TextPainter(
      text: TextSpan(text: text, style: gradientStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    gradientPainter.paint(canvas, Offset(x, y));
  }
}
