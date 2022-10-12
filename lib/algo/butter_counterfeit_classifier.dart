// Use KnnClassifier from ml_algo package
// https://pub.dev/packages/ml_algo

// ignore_for_file: avoid_print
import 'pca_counterfeit_butter.dart';

class ButterCounterfeitClassifier {
  final PCACounterfeitButter _pca = PCACounterfeitButter();
  final Map<int, String> labelTable;

  ButterCounterfeitClassifier({
    this.labelTable = const {
      0: 'Сливочное',
      1: 'Фальсификат',
    },
  });

  Future<String> predict(int r, int g, int b) async {
    // Normalize
    final pca = _pca.scaleTransform(
        [r.roundToDouble(), g.roundToDouble(), b.roundToDouble()]);
    // SVM go brr
    int idxCluster = (1.19 * pca[0] + 0.63 * pca[1] - 0.82 >= 0) ? 1 : 0;
    String label = labelTable[idxCluster]!;
    return label;
  }
}

void main() {
  print('Hello, ButterClassifier!');
  ButterCounterfeitClassifier butterClassifier = ButterCounterfeitClassifier(
    labelTable: const {
      0: 'сливочное72',
      1: 'фальсификат',
    },
  );
  // Test color means
  print(butterClassifier.predict(151, 203, 154));
  print(butterClassifier.predict(130, 217, 234));
  print(butterClassifier.predict(158, 223, 185));
}
