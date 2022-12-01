import 'package:flutter_simple_dependency_injection/injector.dart';

import '../services/ColorService.dart';

class ModuleContainer {
  static Injector initialize(Injector injector) {
    injector.map<ColorService>((i) => ColorService(), isSingleton: true);
    return injector;
  }
}
