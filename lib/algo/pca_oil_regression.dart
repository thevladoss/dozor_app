// ignore_for_file: avoid_print

class PCAOilRegression {
  List<double> scaleTransform(List<double> rgb) {
    // Scale and Transform RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    const dfMean = [214.409091, 182.363636, 154.590909];
    const dfStd = [62.763091, 20.399686, 65.155243];
    rgb = rgb
        .map((e) => (e - dfMean[rgb.indexOf(e)]) / dfStd[rgb.indexOf(e)])
        .toList();
    return [
      rgb[0] * -0.5490246 + rgb[1] * 0.57882346 + rgb[2] * 0.60293896,
      rgb[0] * -0.80406849 + rgb[1] * -0.5626842 + rgb[2] * -0.19199051,
    ];
  }

  List<List<double>> scaleListTransform(List<List<double>> rgbs) {
    //Scale and Transform list of RGBs to PCA space
    List<List<double>> pcaRgbs = [];
    for (var rgb in rgbs) {
      pcaRgbs.add(scaleTransform(rgb));
    }
    return pcaRgbs;
  }
}

double reciprocal(int d) => 1 / d;

void main() {
  final pca = PCAOilRegression();

  // Calculate the principal components for
  // new sample
  List<List<double>> samples = [
    [100, 100, 100],
    [200, 200, 200],
    [255, 255, 255],
  ];
  print(samples);
  print(pca.scaleListTransform(samples));
}
