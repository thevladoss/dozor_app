import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'screens/main_screen.dart';
import 'services/color_service.dart';
import 'generated/l10n.dart';
import 'utils/module_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  ModuleContainer.initialize(Injector());
  runApp(MasloApp(cameras: cameras));
}

class MasloApp extends StatelessWidget {
  final colorService = Injector().get<ColorService>();

  final List<CameraDescription> cameras;

  MasloApp({required this.cameras, Key? key}) : super(key: key);

  // MaterialColor mainColor = MaterialColor(0xff1657A1, color)

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
      theme: ThemeData(),
      home: MainScreen(cameras: cameras),
    );
  }
}
