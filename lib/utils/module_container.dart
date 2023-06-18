import 'package:flutter_simple_dependency_injection/injector.dart';

import '../services/font_service.dart';

class ModuleContainer {
  static Injector initialize(Injector injector) {
    injector.map<FontService>((i) => FontService(), isSingleton: true);
    return injector;
  }
}
