// ignore_for_file: avoid_print

class PCACounterfeitButter {
  List<double> scaleTransform(List<double> rgb) {
    // Scale and Transform RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    const dfMean = [194.7500, 217.2500, 222.3125];
    const dfStd = [10.069757, 9.525405, 19.434398];
    rgb = rgb
        .map((e) => (e - dfMean[rgb.indexOf(e)]) / dfStd[rgb.indexOf(e)])
        .toList();
    return [
      rgb[0] * -0.30217094 + rgb[1] * 0.58121613 + rgb[2] * 0.75556637,
      rgb[0] * -0.812034 + rgb[1] * -0.57210075 + rgb[2] * 0.11533217,
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
  final pca = PCACounterfeitButter();

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
