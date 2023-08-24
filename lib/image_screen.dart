import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatefulWidget {
  ImagePreviewScreen(this.file, {super.key});

  XFile file;

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(picture),
      ),
    );
  }
}
