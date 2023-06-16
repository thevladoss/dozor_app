class DairyAnalyzer {
  final double r;
  final double g;
  final double b;
  final double a1;
  final double a2;
  final List<double> interval;

  get result => b + a1 * r + a2 * g;

  DairyAnalyzer({
    required this.r,
    required this.g,
    required this.b,
    required this.a1,
    required this.a2,
    required this.interval,
  });

  factory DairyAnalyzer.butter({required double r, required double g}) {
    return DairyAnalyzer(
      r: r,
      g: g,
      b: 0.64788446,
      a1: 0.00074337,
      a2: -0.00016862,
      interval: [0.7, 0.85],
    );
  }

  factory DairyAnalyzer.milk({required double r, required double g}) {
    return DairyAnalyzer(
      r: r,
      g: g,
      b: -0.20636096,
      a1: 0.00059706,
      a2: 0.00072699,
      interval: [0.01, 0.07],
    );
  }

  factory DairyAnalyzer.curd({required double r, required double g}) {
    return DairyAnalyzer(
      r: r,
      g: g,
      b: 0.26444533,
      a1: 0.00137956,
      a2: -0.00248443,
      interval: [0.0, 0.2],
    );
  }

  factory DairyAnalyzer.sourCream({required double r, required double g}) {
    return DairyAnalyzer(
      r: r,
      g: g,
      b: 0.13212307,
      a1: 0.00148833,
      a2: -0.00120625,
      interval: [0.1, 0.3],
    );
  }
}
