import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:maslo_detector/screens/DetailScreen.dart';

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
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
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
          children: [
            IconButton(
                icon: const Icon(
                  Icons.history,
                ),
                onPressed: () {}),
            const Spacer(),
            IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () {}),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _initializeControllerFuture;

          final image = await controller.takePicture();

          if (!mounted) return;

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                imagePath: image.path,
              ),
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
