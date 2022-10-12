// ignore_for_file: avoid_print

class PCAOil {
  List<double> scaleTransform(List<double> rgb) {
    // Scale and Transform RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    const dfMean = [176.538462, 182.384615, 174.307692];
    const dfStd = [86.184507, 18.954061, 68.822700];
    rgb = rgb
        .map((e) => (e - dfMean[rgb.indexOf(e)]) / dfStd[rgb.indexOf(e)])
        .toList();
    return [
      rgb[0] * 0.55226792 + rgb[1] * -0.5682887 + rgb[2] * -0.60995745,
      rgb[0] * -0.75665753 + rgb[1] * -0.64882536 + rgb[2] * -0.08059178,
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
  final pca = PCAOil();

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
