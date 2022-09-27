// Use KnnClassifier from ml_algo package
// https://pub.dev/packages/ml_algo

import 'dart:io';

import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

class ButterClassifier {
  late final KnnClassifier _classifier;
  final Map<int, String> labelTable;

  ButterClassifier({
    String pathToCsv = 'data/butter_rgb_with_labels_numbers.csv',
    this.labelTable = const {
      0: 'сливочное',
      1: 'кокосовое',
      2: 'фальсификат',
    },
  }) {
    // Load training Data From CSV
    String csv = File(pathToCsv).readAsStringSync();
    DataFrame trainData = DataFrame.fromRawCsv(csv);

    // Initialize a KNN classifier
    _classifier = KnnClassifier(
      trainData,
      'cluster',
      3,
    );
  }

  String predict(int r, int g, int b) {
    // Define sample data
    final sample = [
      ['R', 'G', 'B'],
      [r, g, b]
    ];
    final df = DataFrame(sample);

    // Predict cluster for sample data
    int idxCluster = _classifier.predict(df).rows.first.first.round();
    return labelTable[idxCluster]!;
  }
}

void main() {
  print('Hello, ButterClassifier!');
  ButterClassifier butterClassifier = ButterClassifier(
    pathToCsv: 'data/butter_rgb_with_labels_numbers.csv',
    labelTable: const {
      0: 'сливочное',
      1: 'кокосовое',
      2: 'фальсификат',
    },
  );
  print(butterClassifier.predict(100, 100, 100));
}
