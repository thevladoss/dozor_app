// Use KnnClassifier from ml_algo package
// https://pub.dev/packages/ml_algo

// ignore_for_file: avoid_print
import 'pca_oil_regression.dart';

class OilRegressor {
  final PCAOilRegression _pca = PCAOilRegression();

  OilRegressor();

  Future<double> predict(int r, int g, int b) async {
    // Predicts percentage of olive oil
    // Normalize
    final pca = _pca.scaleTransform(
        [r.roundToDouble(), g.roundToDouble(), b.roundToDouble()]);
    double regr = 0.49 - 0.17 * pca[0] - 0.03 * pca[1];
    if (regr > 1) {
      regr = 1;
    } else if (regr < 0) {
      regr = 0;
    }
    return regr;
  }
}

void main() async {
  print('Hello, OilRegressor');
  OilRegressor oilClassifier = OilRegressor();
  // Test color means
  print(await oilClassifier.predict(99, 197, 236)); // Это подсолнечка
  print(await oilClassifier.predict(242, 169, 121)); // Это олвки
  print(await oilClassifier.predict(236, 207, 209)); // Это среднее
}
