enum Dairy {
  butter('Масло сливочное'),
  milk('Молоко'),
  curd('Творог'),
  sour('Сметана');

  final String val;
  const Dairy(this.val);
}

enum DairyType { fake, unknown, real }

class DairyAnalyzer {
  final double _r;
  final double _g;
  final double _b;
  final double _a1;
  final double _a2;
  final double _z;
  final double _maxZ;

  get _result => _b + _a1 * _r + _a2 * _g;

  get resultPercent => "${_result.round()}%";

  get dairyType => (_z > _maxZ)
      ? DairyType.fake
      : (_z < _maxZ)
          ? DairyType.real
          : DairyType.unknown;

  DairyAnalyzer._({
    required double r,
    required double g,
    required double b,
    required double a1,
    required double a2,
    required double z,
    required double maxZ,
  })  : _b = b,
        _a2 = a2,
        _a1 = a1,
        _z = z,
        _maxZ = maxZ,
        _g = g,
        _r = r;

  factory DairyAnalyzer.butter({required double r, required double g}) {
    return DairyAnalyzer._(
      r: r,
      g: g,
      b: 124.09959124024195,
      a1: -0.14627642948879238,
      a2: -0.22192706549777988,
      z: 8.671163852605872 + -0.21685354986656763 * r + 0.1930282339596327 * g,
      maxZ: 4.0357,
    );
  }

  factory DairyAnalyzer.milk({required double r, required double g}) {
    return DairyAnalyzer._(
      r: r,
      g: g,
      b: 17.134654991241142,
      a1: 0.4737783169655677,
      a2: -0.44033032836553354,
      z: 15.659540303515476 +
          -0.19395714197877442 * r +
          0.05650543281393807 * g,
      maxZ: 1.4088,
    );
  }

  factory DairyAnalyzer.curd({required double r, required double g}) {
    return DairyAnalyzer._(
      r: r,
      g: g,
      b: 29.247992704605185,
      a1: 0.07735070353691058,
      a2: -0.20708130459779656,
      z: -5.209553066729884 +
          -0.18188736027679964 * r +
          0.17332238496754376 * g,
      maxZ: 1.2992,
    );
  }

  factory DairyAnalyzer.sourCream({required double r, required double g}) {
    return DairyAnalyzer._(
      r: r,
      g: g,
      b: 9.628005105682098,
      a1: 0.1485539050195874,
      a2: -0.09876609913138047,
      z: -7.2532929330692095 +
          -0.05064753636310958 * r +
          0.08501644882327405 * g,
      maxZ: 0.6457,
    );
  }

  factory DairyAnalyzer.fromDairy(
      {required Dairy dairy, required double r, required double g}) {
    switch (dairy) {
      case Dairy.butter:
        return DairyAnalyzer.butter(r: r, g: g);
      case Dairy.milk:
        return DairyAnalyzer.milk(r: r, g: g);
      case Dairy.curd:
        return DairyAnalyzer.curd(r: r, g: g);
      case Dairy.sour:
        return DairyAnalyzer.sourCream(r: r, g: g);
    }
  }
}
