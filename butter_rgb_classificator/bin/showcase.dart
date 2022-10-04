// Read three numbers and print them

import 'package:butter_rgb_classification/predict.dart';

void main() {
  ButterClassifier butterClassifier = ButterClassifier(
    pathToCsv: 'data/butter_rgb_with_labels_numbers.csv',
    labelTable: const {
      0: 'сливочное',
      1: 'кокосовое',
      2: 'фальсификат',
    },
  );

  // Sample
  print(butterClassifier.predict(100, 100, 100));
}
