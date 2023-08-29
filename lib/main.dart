import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.cameras, super.key});

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          // TestScreen(),
          MainScreen(cameras: cameras),
    );
  }
}

// class CameraApp extends StatefulWidget {
//   const CameraApp({super.key});

//   @override
//   State<CameraApp> createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   late CameraController _cameraController;

//   @override
//   void initState() {
//     super.initState();

//     _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
//     _cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: double.infinity,
//           child: CameraPreview(
//             _cameraController,
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: GestureDetector(
//             onTap: () async {
//               if (!_cameraController.value.isInitialized) {
//                 return null;
//               }
//               if (_cameraController.value.isTakingPicture) {
//                 return null;
//               }

//               try {
//                 await _cameraController.setFlashMode(FlashMode.auto);
//                 await _cameraController.setFocusMode(FocusMode.auto);

//                 XFile picture = await _cameraController.takePicture();

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ImagePreviewScreen(picture),
//                   ),
//                 );
//               } on CameraException catch (e) {
//                 debugPrint('Error: $e');
//                 return null;
//               }
//             },
//             child: const Padding(
//               padding: EdgeInsets.symmetric(vertical: 40),
//               child: CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.black,
//                   size: 35,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
