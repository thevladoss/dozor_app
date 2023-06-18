import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
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
