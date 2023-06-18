import 'package:flutter_simple_dependency_injection/injector.dart';

import '../services/color_service.dart';
import '../services/font_service.dart';

class ModuleContainer {
  static Injector initialize(Injector injector) {
    injector.map<ColorService>((i) => ColorService(), isSingleton: true);
    injector.map<FontService>((i) => FontService(), isSingleton: true);
    return injector;
  }
}
