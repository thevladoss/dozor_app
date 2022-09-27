import 'dart:io';

import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Image.file(File(imagePath)),
    );
  }

}