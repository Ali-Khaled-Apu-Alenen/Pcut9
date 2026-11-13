import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';

import 'core/theme/pro9_theme.dart';
import 'core/services/asset_extractor_service.dart';
import 'core/services/preferences_service.dart';
import 'features/editor/cubit/editor_cubit.dart';
import 'features/editor/screens/main_editor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit for video playback
  MediaKit.ensureInitialized();

  // Extract bundled assets to filesystem for FFmpeg access
  await AssetExtractorService.extractAll();

  // Initialize persistent preferences (monitor code, export dir)
  await PreferencesService().init();

  runApp(const Pro9StudioApp());
}

class Pro9StudioApp extends StatelessWidget {
  const Pro9StudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditorCubit(),
      child: MaterialApp(
        title: 'Pro 9 Studio',
        debugShowCheckedModeBanner: false,
        theme: Pro9Theme.darkTheme,
        home: const MainEditorScreen(),
      ),
    );
  }
}
