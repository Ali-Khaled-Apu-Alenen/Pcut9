import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../core/theme/pro9_theme.dart';
import '../cubit/editor_cubit.dart';
import '../models/editor_state.dart';
import 'crop_overlay_widget.dart';
import 'pro9_outro_overlay_widget.dart';

/// Center panel: 16:9 branded preview with gradient border, logo watermark,
/// interactive crop tool, and toggle between Live CCTV Preview / Outro HUD Preview.
class BrandedVideoPreview extends StatefulWidget {
  const BrandedVideoPreview({super.key});

  @override
  State<BrandedVideoPreview> createState() => _BrandedVideoPreviewState();
}

/// Type alias for Clean Architecture presentation naming
typedef BrandedVideoPreviewCanvas = BrandedVideoPreview;

class _BrandedVideoPreviewState extends State<BrandedVideoPreview> {
  Player? _player;
  VideoController? _controller;
  String? _currentPath;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  void _ensurePlayer() {
    if (_player == null) {
      _player = Player();
      _controller = VideoController(_player!);
    }
  }

  void _loadClip(String path) {
    if (path == _currentPath) return;
    _ensurePlayer();
    _currentPath = path;
    _player!.open(Media(path), play: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorCubit, EditorState>(
      builder: (context, state) {
        final showOutro = state.showOutroPreview;
        final isCropMode = state.isCropMode;
        final activeClip = (state.activeClipIndex >= 0 &&
                state.activeClipIndex < state.clips.length)
            ? state.clips[state.activeClipIndex]
            : null;

        // Load active clip into player
        if (!showOutro && activeClip != null) {
          _loadClip(activeClip.filePath);
          _player?.setRate(activeClip.speed);
          _player?.setVolume(activeClip.volume * 100);
        }

        return Column(
          children: [
            // ── Toggle Bar ────────────────────────────────────────────
            _buildToggleBar(context, showOutro, isCropMode, activeClip != null),
            const SizedBox(height: 8),
            // ── 16:9 Preview Canvas ──────────────────────────────────
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildBrandedFrame(
                    context,
                    state,
                    showOutro,
                    isCropMode,
                    activeClip,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleBar(
    BuildContext context,
    bool showOutro,
    bool isCropMode,
    bool hasClip,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ToggleButton(
            label: 'Live CCTV Preview',
            icon: Icons.videocam,
            isActive: !showOutro,
            onTap: () {
              if (showOutro) {
                context.read<EditorCubit>().toggleOutroPreview();
              }
            },
          ),
          const SizedBox(width: 8),
          _ToggleButton(
            label: 'Outro HUD Preview',
            icon: Icons.smart_display,
            isActive: showOutro,
            onTap: () {
              if (!showOutro) {
                context.read<EditorCubit>().toggleOutroPreview();
              }
            },
          ),
          if (hasClip && !showOutro && isCropMode) ...[
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Pro9Theme.glowCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Pro9Theme.glowCyan.withValues(alpha: 0.5)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.crop, size: 14, color: Pro9Theme.glowCyan),
                  SizedBox(width: 6),
                  Text(
                    'Crop Mode ON — Drag Box or Handles',
                    style: TextStyle(
                      color: Pro9Theme.glowCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBrandedFrame(
    BuildContext context,
    EditorState state,
    bool showOutro,
    bool isCropMode,
    VideoClipData? activeClip,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: const LinearGradient(
          colors: [Pro9Theme.frameBorderStart, Pro9Theme.frameBorderEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Pro9Theme.frameBorderStart.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4), // 4px neon border
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Container(
          color: Colors.black,
          child: showOutro
              ? _buildOutroPreview(state)
              : _buildCctvPreview(activeClip, isCropMode),
        ),
      ),
    );
  }

  Widget _buildCctvPreview(VideoClipData? clip, bool isCropMode) {
    if (clip == null || _controller == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Pro9Theme.textMuted),
            SizedBox(height: 12),
            Text(
              'Add clips to preview',
              style: TextStyle(color: Pro9Theme.textMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (isCropMode) {
      // ── Crop Mode ON: Show full video with interactive draggable/resizable crop box
      return Stack(
        fit: StackFit.expand,
        children: [
          Video(
            controller: _controller!,
            fill: Colors.black,
          ),
          CropOverlayWidget(clip: clip),
        ],
      );
    }

    // ── Crop Mode OFF: Scaled preview of the cropped region inside 16:9 canvas
    final hasCrop = clip.cropWidth < 0.999 ||
        clip.cropHeight < 0.999 ||
        clip.cropX > 0.001 ||
        clip.cropY > 0.001;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!hasCrop)
          Video(
            controller: _controller!,
            fill: Colors.black,
          )
        else
          ClipRect(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                final scaleX = 1.0 / clip.cropWidth.clamp(0.1, 1.0);
                final scaleY = 1.0 / clip.cropHeight.clamp(0.1, 1.0);

                return Transform(
                  alignment: Alignment.topLeft,
                  transform: Matrix4.identity()
                    // ignore: deprecated_member_use
                    ..scale(scaleX, scaleY)
                    // ignore: deprecated_member_use
                    ..translate(-clip.cropX * w, -clip.cropY * h),
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Video(
                      controller: _controller!,
                      fill: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

        // Semi-transparent logo watermark (top-right, 24px padding, 140px, opacity 0.65)
        Positioned(
          top: 24,
          right: 24,
          child: Opacity(
            opacity: 0.65,
            child: Image.asset(
              'assets/images/logo.png',
              width: 140,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutroPreview(EditorState state) {
    final report = state.incidentReport ?? const IncidentReport();
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xFF0A1628), Color(0xFF050A12)],
              radius: 1.2,
            ),
          ),
        ),
        Pro9OutroOverlayWidget(
          monitorCode: report.monitorCode.isNotEmpty ? report.monitorCode : 'M001',
          caseName: report.caseName.isNotEmpty ? report.caseName : 'Sample Case Name',
          incidentTime: report.incidentTime.isNotEmpty
              ? report.incidentTime
              : '01-11-2026_21:51',
          incidentDetails: report.incidentDetails.isNotEmpty
              ? report.incidentDetails
              : 'Enter incident details here...',
          animate: true,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? Pro9Theme.primaryBlue : Pro9Theme.cardBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 18,
                  color: isActive ? Colors.white : Pro9Theme.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Pro9Theme.textSecondary,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
