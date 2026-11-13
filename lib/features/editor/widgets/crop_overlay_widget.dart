import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/pro9_theme.dart';
import '../cubit/editor_cubit.dart';
import '../models/editor_state.dart';

/// Interactive draggable & resizable Crop Selection Box overlaid directly
/// on the active video in Crop Mode.
class CropOverlayWidget extends StatelessWidget {
  final VideoClipData clip;

  const CropOverlayWidget({super.key, required this.clip});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final left = (clip.cropX * w).clamp(0.0, w);
        final top = (clip.cropY * h).clamp(0.0, h);
        final width = (clip.cropWidth * w).clamp(20.0, w - left);
        final height = (clip.cropHeight * h).clamp(20.0, h - top);

        return Stack(
          fit: StackFit.expand,
          children: [
            // Shaded darkened mask outside the crop box + grid lines
            CustomPaint(
              painter: _CropMaskPainter(
                cropRect: Rect.fromLTWH(left, top, width, height),
              ),
            ),

            // Draggable inside area (move whole crop box)
            Positioned(
              left: left,
              top: top,
              width: width,
              height: height,
              child: MouseRegion(
                cursor: SystemMouseCursors.move,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    final cubit = context.read<EditorCubit>();
                    final newLeft = (left + details.delta.dx).clamp(0.0, w - width);
                    final newTop = (top + details.delta.dy).clamp(0.0, h - height);
                    cubit.updateCrop(newLeft / w, newTop / h, width / w, height / h);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Pro9Theme.glowCyan, width: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Top-Left Handle
            _buildCornerHandle(
              context: context,
              cx: left,
              cy: top,
              cursor: SystemMouseCursors.resizeUpLeft,
              onPanUpdate: (details) {
                final cubit = context.read<EditorCubit>();
                final minW = 0.1 * w;
                final minH = 0.1 * h;
                final newLeft = (left + details.delta.dx).clamp(0.0, left + width - minW);
                final newTop = (top + details.delta.dy).clamp(0.0, top + height - minH);
                final newW = width + (left - newLeft);
                final newH = height + (top - newTop);
                cubit.updateCrop(newLeft / w, newTop / h, newW / w, newH / h);
              },
            ),

            // Top-Right Handle
            _buildCornerHandle(
              context: context,
              cx: left + width,
              cy: top,
              cursor: SystemMouseCursors.resizeUpRight,
              onPanUpdate: (details) {
                final cubit = context.read<EditorCubit>();
                final minH = 0.1 * h;
                final newW = (width + details.delta.dx).clamp(0.1 * w, w - left);
                final newTop = (top + details.delta.dy).clamp(0.0, top + height - minH);
                final newH = height + (top - newTop);
                cubit.updateCrop(left / w, newTop / h, newW / w, newH / h);
              },
            ),

            // Bottom-Left Handle
            _buildCornerHandle(
              context: context,
              cx: left,
              cy: top + height,
              cursor: SystemMouseCursors.resizeDownLeft,
              onPanUpdate: (details) {
                final cubit = context.read<EditorCubit>();
                final minW = 0.1 * w;
                final newLeft = (left + details.delta.dx).clamp(0.0, left + width - minW);
                final newW = width + (left - newLeft);
                final newH = (height + details.delta.dy).clamp(0.1 * h, h - top);
                cubit.updateCrop(newLeft / w, top / h, newW / w, newH / h);
              },
            ),

            // Bottom-Right Handle
            _buildCornerHandle(
              context: context,
              cx: left + width,
              cy: top + height,
              cursor: SystemMouseCursors.resizeDownRight,
              onPanUpdate: (details) {
                final cubit = context.read<EditorCubit>();
                final newW = (width + details.delta.dx).clamp(0.1 * w, w - left);
                final newH = (height + details.delta.dy).clamp(0.1 * h, h - top);
                cubit.updateCrop(left / w, top / h, newW / w, newH / h);
              },
            ),

            // Dimension / Crop Indicator Badge
            Positioned(
              left: left + 8,
              top: top + 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Pro9Theme.glowCyan.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${(clip.cropWidth * 100).toInt()}% × ${(clip.cropHeight * 100).toInt()}%',
                  style: const TextStyle(
                    color: Pro9Theme.glowCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCornerHandle({
    required BuildContext context,
    required double cx,
    required double cy,
    required MouseCursor cursor,
    required void Function(DragUpdateDetails) onPanUpdate,
  }) {
    const handleSize = 18.0;
    return Positioned(
      left: cx - handleSize / 2,
      top: cy - handleSize / 2,
      child: MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: onPanUpdate,
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: Pro9Theme.glowCyan,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Pro9Theme.glowCyan.withValues(alpha: 0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the dimmed outer mask and rule-of-thirds grid inside the crop rectangle.
class _CropMaskPainter extends CustomPainter {
  final Rect cropRect;

  _CropMaskPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;

    // Dark outer mask
    final maskPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..addRect(fullRect)
      ..addRect(cropRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, maskPaint);

    // Rule of thirds grid lines inside cropRect
    final gridPaint = Paint()
      ..color = Pro9Theme.glowCyan.withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    final x1 = cropRect.left + cropRect.width / 3;
    final x2 = cropRect.left + (cropRect.width * 2) / 3;
    final y1 = cropRect.top + cropRect.height / 3;
    final y2 = cropRect.top + (cropRect.height * 2) / 3;

    canvas.drawLine(Offset(x1, cropRect.top), Offset(x1, cropRect.bottom), gridPaint);
    canvas.drawLine(Offset(x2, cropRect.top), Offset(x2, cropRect.bottom), gridPaint);
    canvas.drawLine(Offset(cropRect.left, y1), Offset(cropRect.right, y1), gridPaint);
    canvas.drawLine(Offset(cropRect.left, y2), Offset(cropRect.right, y2), gridPaint);
  }

  @override
  bool shouldRepaint(covariant _CropMaskPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect;
  }
}

