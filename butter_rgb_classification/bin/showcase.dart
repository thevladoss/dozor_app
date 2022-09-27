// Read three numbers and print them

import 'dart:io';

void main() {
  print("Enter RGB values in format R,G,B");
  String? input = stdin.readLineSync();
  if (input == null) {
    print("No input");
    return;
  }
  List<String> rgb = input.split(",");
  int r = int.parse(rgb[0]);
  int g = int.parse(rgb[1]);
  int b = int.parse(rgb[2]);
  print("R: $r, G: $g, B: $b");
}
