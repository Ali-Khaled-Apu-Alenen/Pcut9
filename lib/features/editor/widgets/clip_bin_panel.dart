import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_kit/media_kit.dart';

import '../../../core/theme/pro9_theme.dart';
import '../cubit/editor_cubit.dart';
import '../models/editor_state.dart';

/// Left panel: Clip Bin & Queue with drag-and-drop zone + reorderable list.
class ClipBinPanel extends StatefulWidget {
  const ClipBinPanel({super.key});

  @override
  State<ClipBinPanel> createState() => _ClipBinPanelState();
}

class _ClipBinPanelState extends State<ClipBinPanel> {
  bool _isDragOver = false;

  Future<void> _importFiles(List<String> paths) async {
    final cubit = context.read<EditorCubit>();
    for (final path in paths) {
      final file = File(path);
      if (!await file.exists()) continue;

      final ext = path.split('.').last.toLowerCase();
      if (!['mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm', 'ts']
          .contains(ext)) {
        continue;
      }

      // Probe duration using media_kit
      Duration duration = const Duration(seconds: 30); // fallback
      try {
        final probe = Player();
        await probe.open(Media(path), play: false);
        // Give it a moment to read metadata
        await Future.delayed(const Duration(milliseconds: 500));
        duration = probe.state.duration;
        if (duration == Duration.zero) {
          duration = const Duration(seconds: 30);
        }
        await probe.dispose();
      } catch (_) {
        // Use fallback duration
      }

      final fileName = path.split(Platform.pathSeparator).last;
      cubit.addClip(path, fileName, duration);
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (result != null && result.paths.isNotEmpty) {
      await _importFiles(
          result.paths.where((p) => p != null).cast<String>().toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: Pro9Theme.cardBg,
        border: Border(
          right: BorderSide(color: Pro9Theme.cardBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          _buildHeader(),
          // ── Drop Zone ───────────────────────────────────────────────
          _buildDropZone(),
          const Divider(color: Pro9Theme.cardBorder, height: 1),
          // ── Clip List ───────────────────────────────────────────────
          Expanded(child: _buildClipList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.video_library, color: Pro9Theme.glowCyan, size: 20),
          const SizedBox(width: 8),
          Text(
            'Clip Bin',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Pro9Theme.textPrimary,
            ),
          ),
          const Spacer(),
          BlocBuilder<EditorCubit, EditorState>(
            builder: (context, state) {
              return Text(
                '${state.clips.length} clips',
                style: const TextStyle(
                    color: Pro9Theme.textMuted, fontSize: 12),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone() {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragOver = true),
      onDragExited: (_) => setState(() => _isDragOver = false),
      onDragDone: (details) {
        setState(() => _isDragOver = false);
        final paths = details.files.map((f) => f.path).toList();
        _importFiles(paths);
      },
      child: GestureDetector(
        onTap: _pickFiles,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: _isDragOver
                ? Pro9Theme.primaryBlue.withValues(alpha: 0.1)
                : Pro9Theme.scaffoldBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _isDragOver ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
              width: _isDragOver ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isDragOver ? Icons.file_download : Icons.add_circle_outline,
                size: 36,
                color: _isDragOver
                    ? Pro9Theme.primaryBlue
                    : Pro9Theme.textMuted,
              ),
              const SizedBox(height: 8),
              Text(
                _isDragOver ? 'Drop clips here' : '+ Add or Drag CCTV Clips',
                style: TextStyle(
                  color: _isDragOver
                      ? Pro9Theme.primaryBlue
                      : Pro9Theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClipList() {
    return BlocBuilder<EditorCubit, EditorState>(
      builder: (context, state) {
        if (state.clips.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No clips added yet.\nDrag & drop video files here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Pro9Theme.textMuted, fontSize: 13),
              ),
            ),
          );
        }

        return ReorderableListView.builder(
          itemCount: state.clips.length,
          buildDefaultDragHandles: false,
          proxyDecorator: (child, index, animation) {
            return Material(
              color: Pro9Theme.primaryBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              elevation: 4,
              child: child,
            );
          },
          onReorder: (oldIndex, newIndex) {
            context.read<EditorCubit>().reorderClips(oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final clip = state.clips[index];
            final isActive = index == state.activeClipIndex;

            return ReorderableDragStartListener(
              key: ValueKey(clip.id),
              index: index,
              child: _ClipTile(
                clip: clip,
                index: index,
                isActive: isActive,
                onTap: () =>
                    context.read<EditorCubit>().setActiveClip(index),
                onDelete: () =>
                    context.read<EditorCubit>().removeClip(index),
              ),
            );
          },
        );
      },
    );
  }
}

class _ClipTile extends StatelessWidget {
  final VideoClipData clip;
  final int index;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClipTile({
    required this.clip,
    required this.index,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Pro9Theme.primaryBlue.withValues(alpha: 0.15)
              : Pro9Theme.scaffoldBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isActive ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Index badge
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? Pro9Theme.primaryBlue : Pro9Theme.cardBorder,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.white : Pro9Theme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clip.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isActive
                          ? Pro9Theme.textPrimary
                          : Pro9Theme.textSecondary,
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDuration(clip.totalDuration),
                    style: const TextStyle(
                      color: Pro9Theme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Delete button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close, size: 16),
              color: Pro9Theme.textMuted,
              hoverColor: Pro9Theme.errorRed.withValues(alpha: 0.1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Remove clip',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

