import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/asset_extractor_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../models/editor_state.dart';
import 'outro_overlay_generator.dart';

/// Exception thrown when FFmpeg executable cannot be found on the system.
class FfmpegNotFoundException implements Exception {
  final String message;
  const FfmpegNotFoundException([this.message = 'FFmpeg executable not found.']);

  @override
  String toString() => 'FfmpegNotFoundException: $message';
}

/// Exception thrown when an FFmpeg process fails.
class FfmpegExecutionException implements Exception {
  final String message;
  final String stderr;
  final String stdout;
  final String command;

  FfmpegExecutionException(
    this.message, {
    this.stderr = '',
    this.stdout = '',
    this.command = '',
  });

  @override
  String toString() =>
      'FfmpegExecutionException: $message\nCommand: $command\nSTDERR (Tail):\n$message';
}

/// Local data source executing bulletproof two-step normalization & concat demuxer.
class FfmpegLocalDataSource {
  FfmpegLocalDataSource._();

  static String? _cachedFfmpegPath;

  /// Callback for progress updates
  static void Function(double progress, String message)? onProgress;

  /// Clear cached path (e.g. after user updates custom path in preferences)
  static void clearCache() {
    _cachedFfmpegPath = null;
  }

  /// Smart FFmpeg Binary Resolver
  static Future<String> resolveFfmpegExecutablePath() async {
    if (_cachedFfmpegPath != null && await _validateExecutable(_cachedFfmpegPath!)) {
      return _cachedFfmpegPath!;
    }

    // 1. Next to the installed executable (Release / Installed App Mode)
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final localExe = p.join(exeDir, 'ffmpeg.exe');
      if (await _validateExecutable(localExe)) {
        _cachedFfmpegPath = localExe;
        return localExe;
      }
    } catch (_) {}

    // 2. Inside extracted / bundled Flutter assets next to the executable
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final assetBin = p.join(exeDir, 'data', 'flutter_assets', 'assets', 'bin', 'ffmpeg.exe');
      if (await _validateExecutable(assetBin)) {
        _cachedFfmpegPath = assetBin;
        return assetBin;
      }
    } catch (_) {}

    // 3. Project assets directory (Development / Debug Mode)
    final projectAssetBin = p.join(Directory.current.path, 'assets', 'bin', 'ffmpeg.exe');
    if (await _validateExecutable(projectAssetBin)) {
      _cachedFfmpegPath = projectAssetBin;
      return projectAssetBin;
    }

    // 4. Custom path saved in SharedPreferences
    final customPath = PreferencesService().customFfmpegPath;
    if (customPath.isNotEmpty && await _validateExecutable(customPath)) {
      _cachedFfmpegPath = customPath;
      return customPath;
    }

    // 5. Application support directory
    try {
      final appSupport = await getApplicationSupportDirectory();
      final supportBin = p.join(appSupport.path, 'ffmpeg.exe');
      if (await _validateExecutable(supportBin)) {
        _cachedFfmpegPath = supportBin;
        return supportBin;
      }
    } catch (_) {}

    // 6. Common Windows WinGet / Chocolatey / Scoop / NPM / Standard paths
    final localAppData = Platform.environment['LOCALAPPDATA'] ?? '';
    final appData = Platform.environment['APPDATA'] ?? '';
    final userProfile = Platform.environment['USERPROFILE'] ?? '';

    final candidatePaths = <String>[
      if (appData.isNotEmpty)
        p.join(appData, 'npm', 'node_modules', '@ffmpeg-installer', 'ffmpeg',
            'node_modules', '@ffmpeg-installer', 'win32-x64', 'ffmpeg.exe'),
      if (localAppData.isNotEmpty) p.join(localAppData, 'Microsoft', 'WinGet', 'Links', 'ffmpeg.exe'),
      'C:\\ffmpeg\\bin\\ffmpeg.exe',
      'C:\\ffmpeg\\ffmpeg.exe',
      'C:\\Program Files\\ffmpeg\\bin\\ffmpeg.exe',
      'C:\\Program Files (x86)\\ffmpeg\\bin\\ffmpeg.exe',
      'C:\\ProgramData\\chocolatey\\bin\\ffmpeg.exe',
      if (userProfile.isNotEmpty) p.join(userProfile, 'scoop', 'shims', 'ffmpeg.exe'),
    ];

    for (final path in candidatePaths) {
      if (await _validateExecutable(path)) {
        _cachedFfmpegPath = path;
        return path;
      }
    }

    // 7. System PATH fallback ('ffmpeg')
    if (await _validateExecutable('ffmpeg')) {
      _cachedFfmpegPath = 'ffmpeg';
      return 'ffmpeg';
    }

    throw const FfmpegNotFoundException(
      'Could not find ffmpeg.exe on this system.\n'
      'Please install FFmpeg or use "Locate ffmpeg.exe" to select your binary.',
    );
  }

  static Future<bool> _validateExecutable(String executablePath) async {
    try {
      if (executablePath != 'ffmpeg' && !await File(executablePath).exists()) {
        return false;
      }
      final res = await Process.run(executablePath, ['-version'], runInShell: true);
      return res.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Probes whether a video file contains at least one audio stream.
  static Future<bool> _hasAudioStream(String ffmpegPath, String filePath) async {
    try {
      final res = await Process.run(
        ffmpegPath,
        ['-hide_banner', '-i', filePath],
        runInShell: true,
      );
      final out = '${res.stdout}\n${res.stderr}';
      return out.contains('Audio:');
    } catch (_) {
      return false;
    }
  }

  /// Bulletproof Two-Step Normalization & Concat Demuxer Pipeline
  static Future<String> export({
    required List<VideoClipData> clips,
    required IncidentReport report,
    required bool includeIntro,
    required bool includeOutro,
    required String outputDir,
  }) async {
    final ffmpegPath = await resolveFfmpegExecutablePath();

    final tempDir = await getTemporaryDirectory();
    final workDir = Directory(
      p.join(tempDir.path, 'pcut9_export_${DateTime.now().millisecondsSinceEpoch}'),
    );
    await workDir.create(recursive: true);

    final tempSegmentFiles = <String>[];

    try {
      _report(0.05, 'Preparing assets...');

      final logoPath = await AssetExtractorService.getLogoPath();
      final introPath = await AssetExtractorService.getIntroPath();
      final outroPath = await AssetExtractorService.getOutroPath();

      // ── Step 1: Normalize Fast Intro (if enabled) ─────────────────────────
      if (includeIntro) {
        _report(0.10, 'Normalizing Intro...');
        final segIntroPath = p.join(workDir.path, 'seg_00_intro.mp4');
        tempSegmentFiles.add(segIntroPath);
        await _normalizeIntro(ffmpegPath, introPath, segIntroPath);
      }

      // ── Step 2: Normalize Each CCTV Clip ──────────────────────────────────
      for (int i = 0; i < clips.length; i++) {
        final clip = clips[i];
        final progress = 0.20 + (0.50 * i / clips.length);
        _report(progress, 'Normalizing CCTV Clip ${i + 1}/${clips.length}...');

        final clipIndexStr = (i + 1).toString().padLeft(2, '0');
        final segClipPath = p.join(workDir.path, 'seg_${clipIndexStr}_clip.mp4');
        tempSegmentFiles.add(segClipPath);
        await _normalizeClip(ffmpegPath, clip, logoPath, segClipPath);
      }

      // ── Step 3: Normalize Outro (if enabled) ──────────────────────────────
      if (includeOutro) {
        _report(0.75, 'Generating Outro typography & HUD overlay...');
        final segOutroPath = p.join(workDir.path, 'seg_99_outro.mp4');
        tempSegmentFiles.add(segOutroPath);
        await _normalizeOutro(ffmpegPath, outroPath, report, segOutroPath, workDir);
      }

      // ── Step 4: Concat Demuxer ────────────────────────────────────────────
      _report(0.85, 'Merging all segments into final video...');
      final concatListPath = p.join(workDir.path, 'concat_list.txt');

      final concatLines = tempSegmentFiles.map((path) {
        final normalized = path.replaceAll('\\', '/').replaceAll("'", "'\\''");
        return "file '$normalized'";
      }).join('\n');

      await File(concatListPath).writeAsString(concatLines);

      // Determine output filename
      String outputFileName;
      if (includeOutro && report.monitorCode.trim().isNotEmpty) {
        final safeCode = report.monitorCode.trim();
        final safeTime = report.incidentTime.trim().isNotEmpty
            ? report.incidentTime.replaceAll(RegExp(r'[^\w\-]'), '_')
            : DateTime.now().millisecondsSinceEpoch.toString();
        outputFileName = '${safeCode}_$safeTime.mp4';
      } else {
        outputFileName = 'PCut9_Export_${DateTime.now().millisecondsSinceEpoch}.mp4';
      }

      final outputPath = p.join(outputDir, outputFileName);
      await Directory(outputDir).create(recursive: true);

      // Fast loss-free stream copy concatenation
      await _runFfmpeg(ffmpegPath, [
        '-f', 'concat',
        '-safe', '0',
        '-i', concatListPath,
        '-c', 'copy',
        '-movflags', '+faststart',
        outputPath,
      ]);

      _report(1.0, 'Export complete!');
      return outputPath;
    } finally {
      // Clean up temporary segment files and directory
      try {
        if (await workDir.exists()) {
          await workDir.delete(recursive: true);
        }
      } catch (_) {}
    }
  }

  /// Normalizes a single CCTV clip to 1920x1080 @ 30fps yuv420p + AAC stereo 48000Hz.
  /// Handles CCTV clips that lack audio by generating a silent audio track.
  static Future<void> _normalizeClip(
    String ffmpegPath,
    VideoClipData clip,
    String logoPath,
    String outputPath,
  ) async {
    final trimStart = _formatDuration(clip.trimStart);
    final trimEnd = clip.trimEnd ?? clip.totalDuration;
    final duration = _formatDuration(trimEnd - clip.trimStart);

    // Force normalized crop coordinates to even integer dimensions
    final cropW = clip.cropWidth.clamp(0.1, 1.0);
    final cropH = clip.cropHeight.clamp(0.1, 1.0);
    final cropX = clip.cropX.clamp(0.0, 1.0 - cropW);
    final cropY = clip.cropY.clamp(0.0, 1.0 - cropH);

    final speedPts = (1.0 / clip.speed).toStringAsFixed(4);
    final hasAudio = await _hasAudioStream(ffmpegPath, clip.filePath);
    final useClipAudio = hasAudio && clip.volume > 0;

    final filterComplex = StringBuffer();

    // 1. Crop (forced even numbers) + Scale + Pad to 1920x1080 + Speed + Pro 9 Blue Frame
    filterComplex.write(
      '[0:v]crop=trunc(iw*${cropW.toStringAsFixed(4)}/2)*2:trunc(ih*${cropH.toStringAsFixed(4)}/2)*2:'
      'trunc(iw*${cropX.toStringAsFixed(4)}/2)*2:trunc(ih*${cropY.toStringAsFixed(4)}/2)*2,'
      'scale=1920:1080:force_original_aspect_ratio=decrease,'
      'pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=0x070B14,'
      'setsar=1,'
      'setpts=$speedPts*PTS,'
      'drawbox=x=0:y=0:w=1920:h=1080:color=#0066FF@0.9:t=5[vbase];',
    );

    // 2. Logo watermark overlay at top-right (24px padding, 140 width, 0.65 opacity)
    final logoInputIndex = useClipAudio ? 1 : 2;
    filterComplex.write(
      '[$logoInputIndex:v]scale=140:-1,format=rgba,colorchannelmixer=aa=0.65[logo];'
      '[vbase][logo]overlay=W-w-24:24[vout]',
    );

    // 3. Audio handling:
    final args = <String>[
      '-ss', trimStart,
      '-t', duration,
      '-i', clip.filePath,
    ];

    if (useClipAudio) {
      // Process clip's own audio
      final atempoChain = _buildAtempoChain(clip.speed);
      filterComplex.write(
        ';[0:a]volume=${clip.volume.toStringAsFixed(2)}$atempoChain,'
        'aresample=48000,aformat=channel_layouts=stereo[aout]',
      );

      args.addAll([
        '-i', logoPath,
        '-filter_complex', filterComplex.toString(),
        '-map', '[vout]',
        '-map', '[aout]',
      ]);
    } else {
      // CCTV clip has NO audio or is muted: inject silent 48000Hz stereo audio
      args.addAll([
        '-f', 'lavfi',
        '-i', 'anullsrc=channel_layout=stereo:sample_rate=48000',
        '-i', logoPath,
        '-filter_complex', filterComplex.toString(),
        '-map', '[vout]',
        '-map', '1:a',
        '-shortest',
      ]);
    }

    args.addAll([
      '-c:v', 'libx264',
      '-preset', 'ultrafast',
      '-crf', '23',
      '-r', '30',
      '-pix_fmt', 'yuv420p',
      '-c:a', 'aac',
      '-b:a', '128k',
      '-ar', '48000',
      '-ac', '2',
      outputPath,
    ]);

    await _runFfmpeg(ffmpegPath, args);
  }

  /// Normalizes the Intro video sped up to 1.5x with 1920x1080 @ 30fps yuv420p + AAC stereo.
  static Future<void> _normalizeIntro(
    String ffmpegPath,
    String introPath,
    String outputPath,
  ) async {
    const filterComplex =
        '[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,'
        'pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=0x070B14,'
        'setsar=1,'
        'setpts=(1/1.5)*PTS[v];'
        '[0:a]atempo=1.5,aresample=48000,aformat=channel_layouts=stereo[a]';

    await _runFfmpeg(ffmpegPath, [
      '-i', introPath,
      '-filter_complex', filterComplex,
      '-map', '[v]',
      '-map', '[a]',
      '-c:v', 'libx264',
      '-preset', 'ultrafast',
      '-crf', '23',
      '-r', '30',
      '-pix_fmt', 'yuv420p',
      '-c:a', 'aac',
      '-b:a', '128k',
      '-ar', '48000',
      '-ac', '2',
      outputPath,
    ]);
  }

  /// Normalizes the Outro HUD video by compositing pure Flutter offscreen canvas
  /// PNG overlay frames (exact coordinates, left-alignment, gradient, glow, and typewriter animation).
  static Future<void> _normalizeOutro(
    String ffmpegPath,
    String outroPath,
    IncidentReport report,
    String outputPath,
    Directory workDir,
  ) async {
    // 1. Generate transparent 1920x1080 PNG frames with exact gradient, glow & typewriter timing
    final framesDir = Directory(p.join(workDir.path, 'outro_frames'));
    await OutroOverlayGenerator.generateFrames(
      outputDir: framesDir,
      monitorCode: report.monitorCode,
      caseName: report.caseName,
      incidentTime: report.incidentTime,
      incidentDetails: report.incidentDetails,
      fps: 30,
      totalDurationSeconds: 8.0,
    );

    // 2. Overlay the PNG sequence on outro_bg.mp4
    final framesPattern = p.join(framesDir.path, 'frame_%04d.png');

    await _runFfmpeg(ffmpegPath, [
      '-i', outroPath,
      '-r', '30',
      '-i', framesPattern,
      '-filter_complex', '[0:v][1:v]overlay=0:0[vout]',
      '-map', '[vout]',
      '-map', '0:a',
      '-c:v', 'libx264',
      '-preset', 'ultrafast',
      '-crf', '23',
      '-r', '30',
      '-pix_fmt', 'yuv420p',
      '-c:a', 'aac',
      '-b:a', '128k',
      '-ar', '48000',
      '-ac', '2',
      outputPath,
    ]);
  }

  // ── FFmpeg Process Runner ────────────────────────────────────────────────

  static Future<void> _runFfmpeg(String ffmpegPath, List<String> args) async {
    // Put -y -hide_banner -loglevel error as the very first arguments
    final fullArgs = <String>[
      '-y',
      '-hide_banner',
      '-loglevel',
      'error',
      ...args.where((a) =>
          a != '-y' &&
          a != '-hide_banner' &&
          a != '-loglevel' &&
          a != 'error'),
    ];

    final result = await Process.run(
      ffmpegPath,
      fullArgs,
      runInShell: true,
      includeParentEnvironment: true,
    );

    if (result.exitCode != 0) {
      final rawStderr = result.stderr.toString().trim();
      final rawStdout = result.stdout.toString().trim();
      final combined = rawStderr.isNotEmpty ? rawStderr : rawStdout;

      // Capture the last 15 lines of stderr
      final allLines = combined.split(RegExp(r'\r?\n'));
      final tailLines = allLines.length > 15
          ? allLines.sublist(allLines.length - 15).join('\n')
          : allLines.join('\n');

      final cmdStr = '$ffmpegPath ${fullArgs.join(' ')}';
      debugPrint('=== FFMPEG ERROR (Exit Code ${result.exitCode}) ===');
      debugPrint('COMMAND: $cmdStr');
      debugPrint('FULL STDERR:\n$rawStderr');
      debugPrint('FULL STDOUT:\n$rawStdout');
      debugPrint('==================================================');

      throw FfmpegExecutionException(
        tailLines.isNotEmpty ? tailLines : 'FFmpeg exited with error code ${result.exitCode}',
        stderr: rawStderr,
        stdout: rawStdout,
        command: cmdStr,
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    final millis = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$hours:$minutes:$seconds.$millis';
  }

  static String _buildAtempoChain(double speed) {
    if ((speed - 1.0).abs() < 0.01) return '';
    final filters = <String>[];
    var remaining = speed;
    while (remaining > 2.0) {
      filters.add('atempo=2.0');
      remaining /= 2.0;
    }
    while (remaining < 0.5) {
      filters.add('atempo=0.5');
      remaining /= 0.5;
    }
    filters.add('atempo=${remaining.toStringAsFixed(2)}');
    return ',${filters.join(",")}';
  }

  static void _report(double progress, String message) {
    onProgress?.call(progress, message);
  }
}
