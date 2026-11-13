import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/pro9_theme.dart';
import '../cubit/editor_cubit.dart';
import '../models/editor_state.dart';

/// Bottom panel: simplified 1-click clip controls for Trim, Crop, Speed, Volume.
class ClipControlsBar extends StatelessWidget {
  const ClipControlsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorCubit, EditorState>(
      builder: (context, state) {
        final clip = (state.activeClipIndex >= 0 &&
                state.activeClipIndex < state.clips.length)
            ? state.clips[state.activeClipIndex]
            : null;

        return Container(
          height: 180,
          decoration: const BoxDecoration(
            color: Pro9Theme.cardBg,
            border: Border(
              top: BorderSide(color: Pro9Theme.cardBorder, width: 1),
            ),
          ),
          child: clip == null
              ? const Center(
                  child: Text(
                    'Select a clip to edit',
                    style: TextStyle(color: Pro9Theme.textMuted, fontSize: 14),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      // ── Trim ─────────────────────────────────────────
                      Expanded(flex: 3, child: _TrimControl(clip: clip)),
                      _divider(),
                      // ── Interactive Crop ─────────────────────────────
                      Expanded(
                        flex: 3,
                        child: _CropControl(
                          clip: clip,
                          isCropMode: state.isCropMode,
                        ),
                      ),
                      _divider(),
                      // ── Speed ────────────────────────────────────────
                      Expanded(flex: 2, child: _SpeedControl(clip: clip)),
                      _divider(),
                      // ── Volume ───────────────────────────────────────
                      Expanded(flex: 2, child: _VolumeControl(clip: clip)),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Pro9Theme.cardBorder,
    );
  }
}

/// Type alias for Clean Architecture presentation naming
typedef SimplifiedClipControlsBar = ClipControlsBar;

// ═══════════════════════════════════════════════════════════════════════════════
// Trim Control
// ═══════════════════════════════════════════════════════════════════════════════
class _TrimControl extends StatelessWidget {
  final VideoClipData clip;
  const _TrimControl({required this.clip});

  @override
  Widget build(BuildContext context) {
    final totalMs = clip.totalDuration.inMilliseconds.toDouble();
    if (totalMs <= 0) return const SizedBox.shrink();

    final startMs = clip.trimStart.inMilliseconds.toDouble();
    final endMs = (clip.trimEnd ?? clip.totalDuration).inMilliseconds.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlLabel('Trim Clip', Icons.content_cut),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(
            startMs.clamp(0, totalMs),
            endMs.clamp(0, totalMs),
          ),
          min: 0,
          max: totalMs,
          divisions: (totalMs / 1000).round().clamp(1, 999),
          labels: RangeLabels(
            _formatMs(startMs.toInt()),
            _formatMs(endMs.toInt()),
          ),
          activeColor: Pro9Theme.primaryBlue,
          inactiveColor: Pro9Theme.cardBorder,
          onChanged: (values) {
            context.read<EditorCubit>().updateTrim(
                  Duration(milliseconds: values.start.toInt()),
                  Duration(milliseconds: values.end.toInt()),
                );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatMs(startMs.toInt()), style: _valueStyle()),
            Text(_formatMs(endMs.toInt()), style: _valueStyle()),
          ],
        ),
      ],
    );
  }

  String _formatMs(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Interactive Crop Control
// ═══════════════════════════════════════════════════════════════════════════════
class _CropControl extends StatelessWidget {
  final VideoClipData clip;
  final bool isCropMode;

  const _CropControl({required this.clip, required this.isCropMode});

  @override
  Widget build(BuildContext context) {
    final hasActiveCrop = clip.cropWidth < 0.999 ||
        clip.cropHeight < 0.999 ||
        clip.cropX > 0.001 ||
        clip.cropY > 0.001;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlLabel('Crop & Frame (قص وتحديد الكادر)', Icons.crop),
        const SizedBox(height: 10),
        Row(
          children: [
            // Toggle Crop Mode button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.read<EditorCubit>().toggleCropMode(),
                icon: Icon(
                  isCropMode ? Icons.check_circle : Icons.crop_free,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  isCropMode ? 'Done Cropping (حفظ القص)' : 'Crop Mode (تحديد الكادر)',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCropMode ? Pro9Theme.glowCyan.withValues(alpha: 0.85) : Pro9Theme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Reset Crop button
            TextButton.icon(
              onPressed: hasActiveCrop ? () => context.read<EditorCubit>().resetCrop() : null,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reset', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: Pro9Theme.glowCyan,
                disabledForegroundColor: Pro9Theme.textMuted,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          hasActiveCrop
              ? 'Crop: ${(clip.cropWidth * 100).toInt()}% × ${(clip.cropHeight * 100).toInt()}% (pos: ${(clip.cropX * 100).toInt()}%, ${(clip.cropY * 100).toInt()}%)'
              : 'Full 16:9 Frame (Uncropped)',
          style: const TextStyle(
            color: Pro9Theme.textMuted,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Speed Control
// ═══════════════════════════════════════════════════════════════════════════════
class _SpeedControl extends StatelessWidget {
  final VideoClipData clip;
  const _SpeedControl({required this.clip});

  static const _speeds = [0.5, 1.0, 1.5, 2.0, 4.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlLabel('Speed', Icons.speed),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _speeds.map((s) {
            final isSelected = (clip.speed - s).abs() < 0.01;
            return ChoiceChip(
              label: Text(
                '${s}x',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Pro9Theme.textSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: Pro9Theme.primaryBlue,
              backgroundColor: Pro9Theme.scaffoldBg,
              side: BorderSide(
                color: isSelected ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
              ),
              onSelected: (_) => context.read<EditorCubit>().updateSpeed(s),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Volume Control
// ═══════════════════════════════════════════════════════════════════════════════
class _VolumeControl extends StatelessWidget {
  final VideoClipData clip;
  const _VolumeControl({required this.clip});

  @override
  Widget build(BuildContext context) {
    final pct = (clip.volume * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlLabel('Volume', Icons.volume_up),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: () => context.read<EditorCubit>().toggleMute(),
              icon: Icon(
                clip.volume > 0 ? Icons.volume_up : Icons.volume_off,
                color: clip.volume > 0 ? Pro9Theme.glowCyan : Pro9Theme.errorRed,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: clip.volume > 0 ? 'Mute' : 'Unmute',
            ),
            Expanded(
              child: Slider(
                value: clip.volume,
                min: 0,
                max: 2.0,
                divisions: 40,
                label: '$pct%',
                onChanged: (v) => context.read<EditorCubit>().updateVolume(v),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text('$pct%', textAlign: TextAlign.right, style: _valueStyle()),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Shared helpers
// ═══════════════════════════════════════════════════════════════════════════════
Widget _controlLabel(String label, IconData icon) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Pro9Theme.glowCyan),
      const SizedBox(width: 6),
      Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Pro9Theme.textPrimary,
        ),
      ),
    ],
  );
}

TextStyle _valueStyle() {
  return const TextStyle(
    color: Pro9Theme.textSecondary,
    fontSize: 11,
    fontFamily: 'monospace',
  );
}
