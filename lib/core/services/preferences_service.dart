import 'package:shared_preferences/shared_preferences.dart';

/// Singleton service wrapping [SharedPreferences] for persistent settings.
///
/// Stores monitor code and default export directory on disk (ROM).
class PreferencesService {
  PreferencesService._internal();
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;

  static const _keyMonitorCode = 'monitor_code';
  static const _keyExportDir = 'export_dir';
  static const _keyCustomFfmpegPath = 'custom_ffmpeg_path';

  SharedPreferences? _prefs;

  /// Must be called once at app startup.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Monitor Code ─────────────────────────────────────────────────────────

  String get monitorCode => _prefs?.getString(_keyMonitorCode) ?? '';

  set monitorCode(String value) {
    _prefs?.setString(_keyMonitorCode, value);
  }

  // ── Default Export Directory ──────────────────────────────────────────────

  String get defaultExportDir => _prefs?.getString(_keyExportDir) ?? '';

  set defaultExportDir(String value) {
    _prefs?.setString(_keyExportDir, value);
  }

  // ── Custom FFmpeg Path ────────────────────────────────────────────────────

  String get customFfmpegPath => _prefs?.getString(_keyCustomFfmpegPath) ?? '';

  set customFfmpegPath(String value) {
    _prefs?.setString(_keyCustomFfmpegPath, value);
  }
}

