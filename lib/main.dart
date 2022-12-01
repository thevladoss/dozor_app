import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'common_setup/ModuleContainer.dart';
import 'generated/l10n.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  ModuleContainer.initialize(Injector());
  runApp(MasloApp(cameras: cameras));
}

class MasloApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MasloApp({required this.cameras, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'DoZor',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MainScreen(cameras: cameras),
    );
  }
}
