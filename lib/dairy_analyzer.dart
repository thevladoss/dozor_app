enum Dairy {
  butter('Масло сливочное'),
  milk('Молоко'),
  curd('Творог'),
  sour('Сметана');

  final String val;
  const Dairy(this.val);
}

class FatInDairyAnalyzer {
  final double _r;
  final double _g;
  final double _b;
  final double _a1;
  final double _a2;
  final bool _falsification;
  final List<double> _interval;

  get _f => _b + _a1 * _r + _a2 * _g;

  get result => (_f < _interval.first)
      ? _interval.first
      : (_f > _interval.last)
          ? _interval.last
          : _f;

  get resultPercent => "${(result * 100).round()}%";

  get isFalsification => _falsification;

  FatInDairyAnalyzer._({
    required double r,
    required double g,
    required double b,
    required double a1,
    required double a2,
    required bool falsification,
    required List<double> interval,
  })  : _interval = interval,
        _b = b,
        _a2 = a2,
        _a1 = a1,
        _falsification = falsification,
        _g = g,
        _r = r;

  factory FatInDairyAnalyzer.butter(
      {required double r, required double g, required bool falsification}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.64788446,
      a1: 0.00074337,
      a2: -0.00016862,
      falsification: falsification,
      interval: [0.7, 0.85],
    );
  }

  factory FatInDairyAnalyzer.milk(
      {required double r, required double g, required bool falsification}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: -0.20636096,
      a1: 0.00059706,
      a2: 0.00072699,
      falsification: falsification,
      interval: [0.01, 0.07],
    );
  }

  factory FatInDairyAnalyzer.curd(
      {required double r, required double g, required bool falsification}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.26444533,
      a1: 0.00137956,
      a2: -0.00248443,
      falsification: falsification,
      interval: [0.0, 0.2],
    );
  }

  factory FatInDairyAnalyzer.sourCream(
      {required double r, required double g, required bool falsification}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.13212307,
      a1: 0.00148833,
      a2: -0.00120625,
      falsification: falsification,
      interval: [0.1, 0.3],
    );
  }

  factory FatInDairyAnalyzer.fromDairy(
      {required Dairy dairy, required double r, required double g}) {
    switch (dairy) {
      case Dairy.butter:
        return FatInDairyAnalyzer.butter(
            r: r, g: g, falsification: (r >= 150 && g <= 120));
      case Dairy.milk:
        return FatInDairyAnalyzer.milk(r: r, g: g, falsification: (r <= 134));
      case Dairy.curd:
        return FatInDairyAnalyzer.curd(
            r: r, g: g, falsification: (g >= 169.5 && r <= 156));
      case Dairy.sour:
        return FatInDairyAnalyzer.sourCream(
            r: r, g: g, falsification: (g >= 170.5 && r <= 163.5));
    }
  }
}
