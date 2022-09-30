class PCAButter {
  List<double> transform(List<double> rgb) {
    // Transform RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    return [
      rgb[0] * -0.24520308 + rgb[1] * 0.11216704 + rgb[2] * 0.96296106,
      rgb[0] * 0.7728561 + rgb[1] * 0.62228628 + rgb[2] * 0.12431103,
    ];
  }

  List<List<double>> listTransform(List<List<double>> rgbs) {
    // Transform list of RGBs to PCA space
    List<List<double>> pcaRgbs = [];
    for (var rgb in rgbs) {
      pcaRgbs.add(transform(rgb));
    }
    return pcaRgbs;
  }
}

double reciprocal(int d) => 1 / d;

void main() {
  print('Hello, PCA!');
  final pca = PCAButter();

  // Calculate the principal components for
  // new sample
  List<List<double>> samples = [
    [100, 100, 100],
    [200, 200, 200],
    [300, 300, 300],
  ];
  print(samples);

  List<List<double>> pcaSample = pca.listTransform(samples);
  print(pcaSample);
}
