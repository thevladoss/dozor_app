import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import '../services/ColorService.dart';

class PrimaryButton extends StatelessWidget {
  final colorService = Injector().get<ColorService>();

  final double height;
  final Color color;
  final VoidCallback onTap;
  final Widget? child;

  PrimaryButton(
      {Key? key,
      required this.height,
      required this.color,
      required this.onTap,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Center(child: child),
        ),
      ),
    );
  }
}
