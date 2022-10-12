// Use KnnClassifier from ml_algo package
// https://pub.dev/packages/ml_algo

// ignore_for_file: avoid_print
import 'dart:math';

import 'pca_oil.dart';

class OilClassifier {
  final PCAOil _pca = PCAOil();
  final Map<int, String> labelTable;

  OilClassifier({
    this.labelTable = const {
      0: 'Подсолнечное',
      1: 'Оливковое',
      2: 'Подсолнечно-оливковое',
    },
  });

  Future<String> predict(int r, int g, int b,
      {bool predictMiddle = true}) async {
    // Normalize
    final pca = _pca.scaleTransform(
        [r.roundToDouble(), g.roundToDouble(), b.roundToDouble()]);
    // Logistic regression go brr
    double proba = 1 / (1 + exp(-(0.36 + 1.58 * pca[0] - 0.2 * pca[1])));

    // TODO: Test coefs for middle on real data
    if (!predictMiddle) {
      if (proba > 0.5) {
        return labelTable[1]!;
      } else {
        return labelTable[0]!;
      }
    } else {
      if (proba >= 0.66) {
        return labelTable[1]!;
      } else if (proba <= 0.33) {
        return labelTable[0]!;
      } else {
        return labelTable[2]!;
      }
    }
  }
}

void main() {
  print('Hello, OilClassifier!');
  OilClassifier oilClassifier = OilClassifier();
  // Test color means
  print(oilClassifier.predict(99, 197, 236)); // Это подсолнечка
  print(oilClassifier.predict(242, 169, 121)); // Это олвки
}
