import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../ui/Buttons.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_images.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.aboutScreenAppBarTitleText),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              _centralAppDescription(),
              SizedBox(height: 55),
              _centralLogoRow(),
              SizedBox(height: 25),
              Spacer(
                flex: 2,
              ),
              _contactDevelopers(),
              Spacer(
                flex: 1,
              ),
              _footerInfo(),
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
      children: <Widget>[
        Image.asset(
          AppImages.assetsArmsGreenIcon,
          width: 170,
          height: 170,
        ),
        Image.asset(
          AppImages.assetsArmsBlueIcon,
          width: 170,
          height: 170,
        )
      ],
    );
  }

  Widget _centralAppDescription() {
    return Column(
      children: <Widget>[
        Text(
          S.current.appName,
          style: TextStyle(
              fontSize: 30,
              fontFamily: AppFonts.openSans,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            S.current.aboutScreenFederalServiceInfoText,
            style: TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.openSans,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _contactDevelopers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: PrimaryButton(
        height: 51,
        color: Color(0xFF1557A1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 19,
                height: 14,
                child: Image.asset(AppImages.assetsContactDevelopersIcon)),
            SizedBox(
              width: 10,
            ),
            Text(
              S.current.aboutScreenContactDevelopers,
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () async {
          final Uri mail = Uri.parse('mailto:<osinvladislav@yandex.ru>');

          if (await launchUrl(mail)) {
            //email app opened
          } else {
            //email app is not opened
          }
        },
      ),
    );
  }

  Widget _footerInfo() {
    return Column(
      children: [
        Text(
          S.current.aboutScreenVersionText,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.openSans,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          S.current.aboutScreenDevelopedBy,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.openSans,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
