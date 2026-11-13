import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../models/editor_state.dart';

/// Editor business-logic cubit.
///
/// Stores ONLY lightweight metadata in RAM — never raw video bytes.
class EditorCubit extends Cubit<EditorState> {
  EditorCubit() : super(const EditorState());

  static const _uuid = Uuid();

  // ── Clip Management ──────────────────────────────────────────────────────

  void addClip(String filePath, String fileName, Duration duration) {
    final clip = VideoClipData(
      id: _uuid.v4(),
      filePath: filePath,
      fileName: fileName,
      totalDuration: duration,
    );
    final updated = [...state.clips, clip];
    emit(state.copyWith(
      clips: updated,
      activeClipIndex: updated.length - 1,
    ));
  }

  void removeClip(int index) {
    if (index < 0 || index >= state.clips.length) return;
    final updated = [...state.clips]..removeAt(index);
    int newActive = state.activeClipIndex;
    if (updated.isEmpty) {
      newActive = -1;
    } else if (index <= newActive) {
      newActive = (newActive - 1).clamp(0, updated.length - 1);
    }
    emit(state.copyWith(clips: updated, activeClipIndex: newActive));
  }

  void reorderClips(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    final updated = [...state.clips];
    final item = updated.removeAt(oldIndex);
    final adjustedNew = newIndex > oldIndex ? newIndex - 1 : newIndex;
    updated.insert(adjustedNew, item);

    int newActive = state.activeClipIndex;
    if (state.activeClipIndex == oldIndex) {
      newActive = adjustedNew;
    }
    emit(state.copyWith(clips: updated, activeClipIndex: newActive));
  }

  void setActiveClip(int index) {
    if (index < 0 || index >= state.clips.length) return;
    emit(state.copyWith(activeClipIndex: index));
  }

  // ── Clip Editing (metadata only) ─────────────────────────────────────────

  void updateTrim(Duration start, Duration end) {
    _updateActive((c) => c.copyWith(trimStart: start, trimEnd: end));
  }

  /// Normalized crop box: x, y in [0.0, 1.0], width, height in [0.1, 1.0]
  void updateCrop(double x, double y, double width, double height) {
    final clampedW = width.clamp(0.1, 1.0);
    final clampedH = height.clamp(0.1, 1.0);
    final clampedX = x.clamp(0.0, 1.0 - clampedW);
    final clampedY = y.clamp(0.0, 1.0 - clampedH);

    _updateActive((c) => c.copyWith(
          cropX: clampedX,
          cropY: clampedY,
          cropWidth: clampedW,
          cropHeight: clampedH,
        ));
  }

  void resetCrop() {
    _updateActive((c) => c.copyWith(
          cropX: 0.0,
          cropY: 0.0,
          cropWidth: 1.0,
          cropHeight: 1.0,
        ));
  }

  void toggleCropMode() {
    emit(state.copyWith(isCropMode: !state.isCropMode));
  }

  void setCropMode(bool value) {
    emit(state.copyWith(isCropMode: value));
  }

  void updateSpeed(double speed) {
    _updateActive((c) => c.copyWith(speed: speed));
  }

  void updateVolume(double volume) {
    _updateActive((c) => c.copyWith(volume: volume.clamp(0.0, 2.0)));
  }

  void toggleMute() {
    final clip = _activeClip;
    if (clip == null) return;
    _updateActive(
        (c) => c.copyWith(volume: clip.volume > 0 ? 0.0 : 1.0));
  }

  // ── Global toggles ──────────────────────────────────────────────────────

  void toggleIntro() {
    emit(state.copyWith(includeIntro: !state.includeIntro));
  }

  void toggleOutro() {
    emit(state.copyWith(includeOutro: !state.includeOutro));
  }

  void toggleOutroPreview() {
    emit(state.copyWith(showOutroPreview: !state.showOutroPreview));
  }

  // ── Incident Report ──────────────────────────────────────────────────────

  void updateIncidentReport(IncidentReport report) {
    emit(state.copyWith(incidentReport: report));
  }

  // ── Export lifecycle ─────────────────────────────────────────────────────

  void setExporting(bool value, {double progress = 0, String message = ''}) {
    emit(state.copyWith(
      isExporting: value,
      exportProgress: progress,
      exportStatusMessage: message,
    ));
  }

  /// Clear clips & report after export, but keep monitorCode.
  void resetAfterExport() {
    emit(const EditorState());
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  VideoClipData? get _activeClip {
    if (state.activeClipIndex < 0 ||
        state.activeClipIndex >= state.clips.length) {
      return null;
    }
    return state.clips[state.activeClipIndex];
  }

  void _updateActive(VideoClipData Function(VideoClipData) updater) {
    final clip = _activeClip;
    if (clip == null) return;
    final updated = [...state.clips];
    updated[state.activeClipIndex] = updater(clip);
    emit(state.copyWith(clips: updated));
  }
}
