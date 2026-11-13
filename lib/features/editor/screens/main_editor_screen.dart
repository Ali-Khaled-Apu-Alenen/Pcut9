import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/pro9_theme.dart';
import '../cubit/editor_cubit.dart';
import '../models/editor_state.dart';
import '../widgets/clip_bin_panel.dart';
import '../widgets/branded_video_preview.dart';
import '../widgets/clip_controls_bar.dart';
import '../widgets/export_report_dialog.dart';

/// Single-screen foolproof workspace: Left Clip Bin, Center Preview, Bottom Controls.
class MainEditorScreen extends StatelessWidget {
  const MainEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Pro9Theme.scaffoldBg,
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────
          _TopBar(),
          // ── Main Content ───────────────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // Left: Clip Bin (300px)
                ClipBinPanel(),
                // Center: Branded Preview (fills remaining)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: BrandedVideoPreview(),
                  ),
                ),
              ],
            ),
          ),
          // ── Bottom: Clip Controls (180px) ──────────────────────────
          ClipControlsBar(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Pro9Theme.cardBg,
        border: Border(
          bottom: BorderSide(color: Pro9Theme.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // App Icon & Title
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/app_icon_cut.png',
              height: 32,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/logo.png',
                height: 32,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.remove_red_eye,
                  color: Pro9Theme.glowCyan,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Pro 9 Studio',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Pro9Theme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Pro9Theme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'v1.0',
              style: TextStyle(
                color: Pro9Theme.primaryBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),

          // Export Button
          BlocBuilder<EditorCubit, EditorState>(
            builder: (context, state) {
              final hasClips = state.clips.isNotEmpty;
              return ElevatedButton.icon(
                onPressed: hasClips
                    ? () => ExportReportDialog.show(context)
                    : null,
                icon: const Icon(Icons.movie_creation, size: 18),
                label: const Text('Export Report Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasClips ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Pro9Theme.cardBorder,
                  disabledForegroundColor: Pro9Theme.textMuted,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

