import 'dart:io';
import 'package:ml_linalg/linalg.dart';

class PCA {
  PCA(Matrix trainData, {int nVariables = 2}) {
    // Center data
    final mean = trainData.mean();

    // For every row, subtract the mean of the
    final centeredData = trainData.mapRows((row) => row - mean);

    // Calculate covariance matrix step by step
    Matrix cov = centeredData.transpose() * centeredData;
    // cov /= trainData.rowsNum - 1;

    // Calculate eigenvalues and eigenvectors
    final eigen = cov.eigen().toList();

    // Sort the eigenvalues in descending order
    eigen.sort();
    print("eigen: $eigen");
  }

  List<double> transform(List<double> data) {
    return [];
  }
}

double reciprocal(int d) => 1 / d;

void main() {
  // Read list from csv file
  String csv =
      File('data/butter_rgb_with_labels_numbers.csv').readAsStringSync();

  // Ignore first line in multiline string
  csv = csv.split('\n').skip(1).join('\n');

  print(csv);
  // Take only first three columns
  List<List<double>> data = csv
      .split('\n')
      .map((e) => e.split(',').take(3).map(int.parse).map(reciprocal).toList())
      .toList();
  // Convert to Matrix
  Matrix csvMatrix = Matrix.fromList(data);

  // Normalize data in each column
  List<Vector> cols = csvMatrix.columns.map((e) => e.normalize()).toList();
  csvMatrix = Matrix.fromColumns(cols);
  print("csvMatrix: $csvMatrix");

  print('Hello, PCA!');
  final pca = PCA(
    csvMatrix,
    nVariables: 2,
  );

  // Calculate the principal components for
  // new sample
  List<double> sample = [100, 100, 100];
  print(sample);

  List<double> pca_sample = pca.transform(sample);
  print(pca_sample);
}
