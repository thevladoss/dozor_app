import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'AboutScreen.dart';
import 'DetailScreen.dart';

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainScreen({required this.cameras, Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
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
      body: Transform.scale(
        scale: 1 /
            (controller.value.aspectRatio *
                MediaQuery.of(context).size.aspectRatio),
        alignment: Alignment.topCenter,
        child: CameraPreview(controller),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightGreen,
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 4.0,
            ),
            IconButton(
                icon: const Icon(
                  Icons.photo_outlined,
                  size: 30,
                ),
                onPressed: () async {
                  XFile? pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    _openDetailScreen(path: pickedFile.path);
                  }
                }),
            const Spacer(),
            IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutScreen()));
                }),
            const SizedBox(
              width: 4.0,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _initializeControllerFuture;

          final image = await controller.takePicture();

          if (!mounted) return;

          _openDetailScreen(path: image.path);
        },
        child: const Icon(
          Icons.camera_alt,
          size: 25,
        ),
      ),
    );
  }

  _openDetailScreen({required String path}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          imagePath: path,
        ),
      ),
    );
  }
}
