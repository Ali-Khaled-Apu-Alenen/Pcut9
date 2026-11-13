import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:pcut9/features/editor/data/datasources/ffmpeg_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('resolveFfmpegExecutablePath finds and executes ffmpeg', () async {
    SharedPreferences.setMockInitialValues({});
    final path = await FfmpegLocalDataSource.resolveFfmpegExecutablePath();
    expect(path, isNotEmpty);
    print('RESOLVED FFMPEG PATH: $path');

    final result = await Process.run(path, ['-version']);
    expect(result.exitCode, equals(0));
    print('FFMPEG VERSION: ${result.stdout.toString().split('\n').first}');
  });
}

