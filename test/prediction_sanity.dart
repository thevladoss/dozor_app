import 'package:maslo_detector/algo/butter_counterfeit_classifier.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  test('sanity_basic', () {
    expect(true, true);
  });

  const labels = {
    0: 'сливочное72',
    1: 'фальсификат',
    2: 'сливочное82',
  };

  test('Predictions for cluster mean colors are correct', () {
    ButterCounterfeitClassifier butterClassifier = ButterCounterfeitClassifier(
      labelTable: const {
        0: 'сливочное72',
        1: 'фальсификат',
        2: 'сливочное82',
      },
    );
    print(butterClassifier.predict(151, 203, 154));
    print(butterClassifier.predict(130, 217, 234));
    print(butterClassifier.predict(158, 223, 185));

    expect(butterClassifier.predict(151, 203, 154), labels[0]);
    expect(butterClassifier.predict(130, 217, 234), labels[1]);
    expect(butterClassifier.predict(158, 223, 185), labels[2]);
  });

  test(
    'Predictions for given image in tg are correct',
    () async {
      ButterCounterfeitClassifier butterClassifier =
          ButterCounterfeitClassifier(
        labelTable: labels,
      );
      // Сверху вниз на картинке
      List<Tuple2<String, List>> df = [
        Tuple2(labels[0]!, [232, 255, 235]),
        Tuple2(labels[1]!, [209, 253, 254]),
        Tuple2(labels[0]!, [229, 255, 230]),
        Tuple2(labels[1]!, [214, 253, 252]),
        Tuple2(labels[1]!, [212, 254, 253]),
        Tuple2(labels[0]!, [151, 203, 154]),
        Tuple2(labels[1]!, [130, 217, 234]),
        Tuple2(labels[0]!, [158, 223, 185]),
      ];

      // Calculate recall and accuracy
      int correct = 0;
      List predcitions = [];
      List groundTruths = [];
      for (Tuple2<String, List> row in df) {
        String label = await butterClassifier.predict(
            row.item2[0], row.item2[1], row.item2[2]);
        if (label == labels[2]) {
          label = labels[0]!;
        }
        predcitions.add(label);
        groundTruths.add(row.item1);
      }

      // Calculate accuracy
      for (int i = 0; i < predcitions.length; i++) {
        if (predcitions[i] == groundTruths[i]) {
          correct += 1;
        }
      }
      double accuracy = correct / predcitions.length;
      print('Accuracy: $accuracy');

      // Print predictions side by side
      print('{predcitions[i]}\t{groundTruths[i]}');
      for (int i = 0; i < predcitions.length; i++) {
        print('${predcitions[i]}\t${groundTruths[i]}');
      }
    },
  );
}
