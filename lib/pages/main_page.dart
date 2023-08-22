import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../dairy_analyzer.dart';
import '../utils/app_colors.dart';
import '../utils/app_icons.dart';
import 'about_page.dart';
import 'detail_page.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  Dairy _activeDairy = Dairy.butter;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return _buildLoadingPage();
    }
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        ((Platform.isIOS) ? 0.75 : 0.8),
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Transform.scale(
                        scale: 1,
                        child: CameraPreview(controller),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      strokeWidth: 4,
                      color: Colors.white,
                      borderPadding: EdgeInsets.all(2),
                      strokeCap: StrokeCap.round,
                      dashPattern: [25, 15],
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  _buildAppBar()
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    _buildIconButton(
                      icon: AppIcons.gallery,
                      onTap: () async {
                        XFile? pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          _openDetailScreen(path: pickedFile.path);
                        }
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    _buildPhotoButton(),
                    Spacer(
                      flex: 2,
                    ),
                    _buildIconButton(
                      icon: AppIcons.info,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutPage(),
                          ),
                        );
                      },
                    ),
                    Spacer()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildAppBar() {
    return Container(
      height: 129,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Spacer(),
          Text(
            "Сфотографируйте образец",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.primary),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CupertinoSlidingSegmentedControl<Dairy>(
              backgroundColor: AppColors.primary,
              thumbColor: AppColors.accent,
              groupValue: _activeDairy,
              children: const <Dairy, Widget>{
                Dairy.butter: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Масло',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
                Dairy.curd: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Творог',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
                Dairy.milk: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Молоко',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
                Dairy.sour: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Сметана',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
              },
              onValueChanged: (Dairy? value) {
                if (value != null) {
                  setState(() {
                    _activeDairy = value;
                  });
                }
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Container _buildLoadingPage() {
    return Container(
      color: AppColors.primary,
      child: CupertinoActivityIndicator(
        color: Colors.white,
      ),
    );
  }

  Container _buildPhotoButton() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: AppColors.primaryLight, width: 6)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () async {
            await _initializeControllerFuture;

            final image = await controller.takePicture();

            if (!mounted) return;

            _openDetailScreen(path: image.path);
          },
          child: Container(),
        ),
      ),
    );
  }

  Container _buildIconButton(
      {required IconData icon, required Function() onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryDark,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 40,
            width: 40,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _openDetailScreen({required String path}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(
          imagePath: path,
          dairy: _activeDairy,
        ),
      ),
    );
  }
}
