import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import '../../generated/l10n.dart';
import '../common_setup/Assets.dart';
import '../services/ColorService.dart';

class AboutScreen extends StatelessWidget {
  final colorService = Injector().get<ColorService>();

  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.aboutScreenAppBarTitleText),
        backgroundColor: colorService.primaryColor(),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              _centralLogoRow(),
              SizedBox(height: 25),
              _centralAppDescription(),
              Spacer(),
              Text(S.current.aboutScreenVersionText),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _centralLogoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          A.assetsArmsGreenIcon,
          width: 170,
          height: 170,
        ),
        Image.asset(
          A.assetsArmsBlueIcon,
          width: 170,
          height: 170,
        )
      ],
    );
  }

  Widget _centralAppDescription() {
    return Column(
      children: [
        Text(
          S.current.appName,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            S.current.aboutScreenFederalServiceInfoText,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
