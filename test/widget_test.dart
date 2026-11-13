import 'package:flutter_test/flutter_test.dart';
import 'package:pcut9/features/editor/models/editor_state.dart';

void main() {
  test('VideoClipData entity defaults to full frame crop', () {
    const clip = VideoClipData(
      id: 'test-1',
      filePath: 'dummy.mp4',
      fileName: 'dummy.mp4',
      totalDuration: Duration(seconds: 10),
    );

    expect(clip.cropX, equals(0.0));
    expect(clip.cropY, equals(0.0));
    expect(clip.cropWidth, equals(1.0));
    expect(clip.cropHeight, equals(1.0));
  });

  test('IncidentReport entity defaults both Intro and Outro to true', () {
    const report = IncidentReport();
    expect(report.includeIntro, isTrue);
    expect(report.includeOutro, isTrue);
  });
}
