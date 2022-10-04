// Read three numbers and print them

import 'package:maslo_detector/algo/predict.dart';

void main() {
  ButterClassifier butterClassifier = ButterClassifier(
  );

  // Sample
  print(butterClassifier.predict(100, 100, 100));
}
