import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_test_app/image_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({required this.cameras, super.key});
  final List<CameraDescription> cameras;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CameraController _cameraController;

  @override
  void initState() {
    startCamera();

    getUserCurrentLocation();
    super.initState();
  }

  void startCamera() async {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.max);

    await _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<Position> getUserCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  @override
  void dispose() {
    _cameraController.dispose();

    getUserCurrentLocation();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: CameraPreview(_cameraController),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  final Position position = await getUserCurrentLocation();

                  _cameraController.setFlashMode(FlashMode.always);
                  _cameraController.setFocusMode(FocusMode.auto);

                  _cameraController.takePicture().then((XFile picture) {
                    debugPrint('picture is tacken');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewScreen(
                          picture,
                          position.latitude.toString(),
                          position.longitude.toString(),
                        ),
                      ),
                    );
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
