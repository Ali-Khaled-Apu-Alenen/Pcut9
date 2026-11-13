import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_state.freezed.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RAM-only metadata models (Domain Entities) — NO raw video bytes in RAM.
// ─────────────────────────────────────────────────────────────────────────────

/// Lightweight metadata for a single imported CCTV clip.
@freezed
abstract class VideoClipData with _$VideoClipData {
  const factory VideoClipData({
    required String id,
    required String filePath,
    required String fileName,
    required Duration totalDuration,
    @Default(Duration.zero) Duration trimStart,
    Duration? trimEnd,
    // Normalized crop box: x, y in [0.0, 1.0], width, height in [0.1, 1.0]
    @Default(0.0) double cropX,
    @Default(0.0) double cropY,
    @Default(1.0) double cropWidth,
    @Default(1.0) double cropHeight,
    @Default(1.0) double speed,
    @Default(1.0) double volume,
  }) = _VideoClipData;
}

/// Type alias for Clean Architecture domain layer
typedef VideoClipEntity = VideoClipData;

/// Incident report fields for the outro overlay.
@freezed
abstract class IncidentReport with _$IncidentReport {
  const factory IncidentReport({
    @Default('') String monitorCode,
    @Default('') String caseName,
    @Default('') String incidentTime,
    @Default('') String incidentDetails,
    @Default(true) bool includeIntro,
    @Default(true) bool includeOutro,
  }) = _IncidentReport;
}

/// Type alias for Clean Architecture domain layer
typedef IncidentReportEntity = IncidentReport;

/// The complete editor state held in RAM by [EditorCubit].
@freezed
abstract class EditorState with _$EditorState {
  const factory EditorState({
    @Default([]) List<VideoClipData> clips,
    @Default(-1) int activeClipIndex,
    @Default(true) bool includeIntro,
    @Default(true) bool includeOutro,
    @Default(false) bool isCropMode,
    @Default(false) bool isExporting,
    @Default(0.0) double exportProgress,
    @Default('') String exportStatusMessage,
    @Default(false) bool showOutroPreview,
    IncidentReport? incidentReport,
  }) = _EditorState;
}
