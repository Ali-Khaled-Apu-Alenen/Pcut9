import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pcut9/features/editor/data/datasources/ffmpeg_local_data_source.dart';
import 'package:pcut9/features/editor/models/editor_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return '${Directory.current.path}\\assets';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Full export pipeline succeeds with CCTV clip without audio', () async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    SharedPreferences.setMockInitialValues({});

    final ffmpegPath = await FfmpegLocalDataSource.resolveFfmpegExecutablePath();
    expect(ffmpegPath, isNotEmpty);

    // Create a dummy 2-second CCTV clip without audio in temp
    final tempDir = Directory.systemTemp.createTempSync('pcut9_test_');
    final dummyCctvPath = '${tempDir.path}\\dummy_cctv.mp4';

    final genResult = await Process.run(
      ffmpegPath,
      [
        '-y',
        '-hide_banner',
        '-loglevel',
        'error',
        '-f',
        'lavfi',
        '-i',
        'color=c=gray:s=1280x720:d=2',
        '-c:v',
        'libx264',
        '-pix_fmt',
        'yuv420p',
        dummyCctvPath,
      ],
      runInShell: true,
    );
    expect(genResult.exitCode, equals(0));
    expect(File(dummyCctvPath).existsSync(), isTrue);

    // Run full export pipeline
    final clip = VideoClipData(
      id: 'clip-1',
      filePath: dummyCctvPath,
      fileName: 'dummy_cctv.mp4',
      totalDuration: const Duration(seconds: 2),
      cropX: 0.1,
      cropY: 0.1,
      cropWidth: 0.8,
      cropHeight: 0.8,
      speed: 1.0,
      volume: 1.0, // Clip has no audio, tests that volume is handled safely!
    );

    const report = IncidentReport(
      monitorCode: 'M002',
      caseName: 'Test Case',
      incidentTime: '01-11-2026_21:51',
      incidentDetails: 'Suspect observed entering',
      includeIntro: true,
      includeOutro: true,
    );

    final outputPath = await FfmpegLocalDataSource.export(
      clips: [clip],
      report: report,
      includeIntro: true,
      includeOutro: true,
      outputDir: tempDir.path,
    );

    expect(outputPath, isNotEmpty);
    final outputFile = File(outputPath);
    expect(outputFile.existsSync(), isTrue);
    expect(outputFile.lengthSync(), greaterThan(100000));
    print('SUCCESSFULLY EXPORTED TO: $outputPath (${outputFile.lengthSync()} bytes)');

    // Cleanup
    tempDir.deleteSync(recursive: true);
  });
}
