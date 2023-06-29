import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      return Container();
    }
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.75,
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
                    Container(
                      height: 68,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Text(
                        "Сфотографируйте образец",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.primary),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () async {
                                  XFile? pickedFile =
                                      await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    _openDetailScreen(path: pickedFile.path);
                                  }
                                },
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutPage(),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 70,
                              height: 60,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    AppIcons.butter,
                                  ),
                                  Text(
                                    "Подробнее",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.primaryLight, width: 6)),
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
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  _openDetailScreen({required String path}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(
          imagePath: path,
        ),
      ),
    );
  }
}

// class MainPage extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const MainPage({required this.cameras, Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   late CameraController controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(
//       widget.cameras[0],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     _initializeControllerFuture = controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {});
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       body: Transform.scale(
//         scale: 1 /
//             (controller.value.aspectRatio *
//                 MediaQuery.of(context).size.aspectRatio),
//         alignment: Alignment.topCenter,
//         child: CameraPreview(controller),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: AppColors.primary,
//         shape: const CircularNotchedRectangle(),
//         child: Row(
//           children: <Widget>[
//             const SizedBox(
//               width: 4.0,
//             ),
//             IconButton(
//               icon: const Icon(
//                 Icons.photo_outlined,
//                 color: Colors.white,
//                 size: 30,
//               ),
//               onPressed: () async {
//                 XFile? pickedFile = await ImagePicker().pickImage(
//                   source: ImageSource.gallery,
//                 );
//                 if (pickedFile != null) {
//                   _openDetailScreen(path: pickedFile.path);
//                 }
//               },
//             ),
//             const Spacer(),
//             IconButton(
//                 icon: const Icon(
//                   Icons.info_outline,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => AboutPage()));
//                 }),
//             const SizedBox(
//               width: 4.0,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await _initializeControllerFuture;

//           final image = await controller.takePicture();

//           if (!mounted) return;

//           _openDetailScreen(path: image.path);
//         },
//         backgroundColor: AppColors.primary,
//         child: const Icon(
//           Icons.camera_alt,
//           size: 25,
//         ),
//       ),
//     );
//   }

//   _openDetailScreen({required String path}) async {
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => DetailPage(
//           imagePath: path,
//         ),
//       ),
//     );
//   }
// }
