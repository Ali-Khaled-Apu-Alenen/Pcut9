import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Extracts bundled assets from Flutter's rootBundle to the filesystem
/// so that native FFmpeg can access them via real file paths.
class AssetExtractorService {
  AssetExtractorService._();

  static String? _basePath;

  /// Base directory where extracted assets live.
  static Future<String> get _assetsDir async {
    if (_basePath != null) return _basePath!;
    final appSupport = await getApplicationSupportDirectory();
    _basePath = p.join(appSupport.path, 'pro9_assets');
    return _basePath!;
  }

  /// Copy all three required assets if they don't already exist on disk.
  static Future<void> extractAll() async {
    final base = await _assetsDir;
    await Directory(base).create(recursive: true);

    await _extractIfMissing('assets/images/logo.png', p.join(base, 'logo.png'));
    await _extractIfMissing(
        'assets/videos/intro.mp4', p.join(base, 'intro.mp4'));
    await _extractIfMissing(
        'assets/videos/outro_bg.mp4', p.join(base, 'outro_bg.mp4'));
    try {
      await _extractIfMissing(
          'assets/bin/ffmpeg.exe', p.join(base, 'ffmpeg.exe'));
    } catch (_) {}
  }

  static Future<void> _extractIfMissing(
      String assetKey, String destPath) async {
    final file = File(destPath);
    if (await file.exists()) return;

    final data = await rootBundle.load(assetKey);
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
  }

  // ── Convenience getters ──────────────────────────────────────────────────

  static Future<String> getLogoPath() async {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundled = p.join(exeDir, 'data', 'flutter_assets', 'assets', 'images', 'logo.png');
      if (await File(bundled).exists()) return bundled;
    } catch (_) {}
    final extracted = p.join(await _assetsDir, 'logo.png');
    if (await File(extracted).exists()) return extracted;
    final local = p.join(Directory.current.path, 'assets', 'images', 'logo.png');
    if (await File(local).exists()) return local;
    return extracted;
  }

  static Future<String> getIntroPath() async {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundled = p.join(exeDir, 'data', 'flutter_assets', 'assets', 'videos', 'intro.mp4');
      if (await File(bundled).exists()) return bundled;
    } catch (_) {}
    final extracted = p.join(await _assetsDir, 'intro.mp4');
    if (await File(extracted).exists()) return extracted;
    final local = p.join(Directory.current.path, 'assets', 'videos', 'intro.mp4');
    if (await File(local).exists()) return local;
    return extracted;
  }

  static Future<String> getOutroPath() async {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundled = p.join(exeDir, 'data', 'flutter_assets', 'assets', 'videos', 'outro_bg.mp4');
      if (await File(bundled).exists()) return bundled;
    } catch (_) {}
    final extracted = p.join(await _assetsDir, 'outro_bg.mp4');
    if (await File(extracted).exists()) return extracted;
    final local = p.join(Directory.current.path, 'assets', 'videos', 'outro_bg.mp4');
    if (await File(local).exists()) return local;
    return extracted;
  }

  static Future<String> getFfmpegPath() async =>
      p.join(await _assetsDir, 'ffmpeg.exe');
}

