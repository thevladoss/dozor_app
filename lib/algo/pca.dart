class PCAButter {
  List<double> transform(List<double> rgb) {
    // Transform scaled RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    return [
      rgb[0] * -0.60146571 + rgb[1] * 0.33104085 + rgb[2] * 0.72708387,
      rgb[0] * 0.53413964 + rgb[1] * 0.8434146 + rgb[2] * 0.05785026,
    ];
  }

  List<double> scaleTransform(List<double> rgb) {
    // Scale and Transform RGB to PCA space
    // Coefficents are from docs/1.1_TIS_EDA.ipynb
    const df_mean = [194.7500, 217.2500, 222.3125];
    const df_std = [10.069757, 9.525405, 19.434398];
    rgb = rgb
        .map((e) => (e - df_mean[rgb.indexOf(e)]) / df_std[rgb.indexOf(e)])
        .toList();
    return [
      rgb[0] * -0.30217094 + rgb[1] * 0.58121613 + rgb[2] * 0.75556637,
      rgb[0] * -0.812034 + rgb[1] * -0.57210075 + rgb[2] * 0.11533217,
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
