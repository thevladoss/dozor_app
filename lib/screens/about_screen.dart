import 'dart:io';

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("О приложении"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('img/ArmsGreen.png',
                  width: 200,
                  height: 200,),
                  Image.asset('img/ArmsBlue.png',
                  width: 200,
                  height: 200,)
                ],
              ),
              SizedBox(height: 25),
              Text('Dazor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Россельхознадзор- федеральная служба по ветеринарному и фитосанитарному надзору', style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,),
              ),
              Spacer(),
              Text("Весряи 1.0.0")
            ],

          ),
        ),
      )
    );
  }
}
