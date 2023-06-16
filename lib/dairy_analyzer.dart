void main() {
  print(FatInDairyAnalyzer.milk(r: 255, g: 255).resultPercent);
}

class FatInDairyAnalyzer {
  final double _r;
  final double _g;
  final double _b;
  final double _a1;
  final double _a2;
  final List<double> _interval;

  get _f => _b + _a1 * _r + _a2 * _g;

  get result => (_f < _interval.first)
      ? _interval.first
      : (_f > _interval.last)
          ? _interval.last
          : _f;

  get resultPercent => "${(result * 100).round()}%";

  FatInDairyAnalyzer._({
    required double r,
    required double g,
    required double b,
    required double a1,
    required double a2,
    required List<double> interval,
  })  : _interval = interval,
        _b = b,
        _a2 = a2,
        _a1 = a1,
        _g = g,
        _r = r;

  factory FatInDairyAnalyzer.butter({required double r, required double g}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.64788446,
      a1: 0.00074337,
      a2: -0.00016862,
      interval: [0.7, 0.85],
    );
  }

  factory FatInDairyAnalyzer.milk({required double r, required double g}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: -0.20636096,
      a1: 0.00059706,
      a2: 0.00072699,
      interval: [0.01, 0.07],
    );
  }

  factory FatInDairyAnalyzer.curd({required double r, required double g}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.26444533,
      a1: 0.00137956,
      a2: -0.00248443,
      interval: [0.0, 0.2],
    );
  }

  factory FatInDairyAnalyzer.sourCream({required double r, required double g}) {
    return FatInDairyAnalyzer._(
      r: r,
      g: g,
      b: 0.13212307,
      a1: 0.00148833,
      a2: -0.00120625,
      interval: [0.1, 0.3],
    );
  }
}
