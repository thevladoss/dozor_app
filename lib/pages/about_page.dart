import 'package:DoZor/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../ui/Buttons.dart';
import '../utils/app_colors.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              _appBar(context),
              Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Dozor',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black333),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Россельхознадзор - федеральная служба по ветеринарному и фитосанитарному надзору',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black333,
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/ArmsGreen.png',
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Image.asset('assets/images/ArmsBlue.png'),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              _contactDevelopers(),
              Spacer(),
              _footerInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Container _appBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              AppIcons.back,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'О приложении',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactDevelopers() {
    return PrimaryButton(
      height: 51,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.send,
            color: AppColors.primary,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            S.current.aboutScreenContactDevelopers,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
    );
  }

  Widget _footerInfo() {
    return Column(
      children: [
        Text(
          'Версия 2.0',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.grey,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          'Дизайн: Ника Молоткова\nРазработчики: Илья Тампио и Владислав Осин',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.grey,
          ),
        )
      ],
    );
  }
}
