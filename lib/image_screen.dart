import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ImagePreviewScreen extends StatefulWidget {
  ImagePreviewScreen(this.file, this.latitude, this.longitude, {super.key});

  XFile file;
  String latitude;
  String longitude;

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

TextEditingController _commentController = TextEditingController();

bool _dataIsSending = false;

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Image.file(picture),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter comments',
                          ),
                          maxLines: 5,
                          minLines: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _dataIsSending = true;
                          });

                          var url = Uri.parse(
                            // 'https://flutter-sandbox.free.beeceptor.com/upload_photo/'
                            'https://flutter-img.free.beeceptor.com/todos',
                          );

                          var request = http.MultipartRequest("POST", url)
                            ..headers['Content-Type'] = 'application/javascript'
                            ..fields['comment'] = _commentController.text
                            ..fields['latitude'] = widget.latitude
                            ..fields['longitude'] = widget.longitude
                            ..files.add(
                              await http.MultipartFile.fromPath(
                                'photo',
                                picture.path,
                              ),
                            );

                          try {
                            var response = await request.send();

                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Comments sent successfully',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );

                              setState(() {
                                _dataIsSending = false;
                              });

                              _commentController.clear();

                              Navigator.pop(context);

                              debugPrint(
                                  'Успешный ответ от сервера: ${response.statusCode}');
                            } else {
                              debugPrint(
                                  'Ошибка запроса: ${response.statusCode}');
                            }
                          } catch (e) {
                            debugPrint('Error: $e');
                          }
                          picture.delete();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _dataIsSending == true
                ? Container(
                    height: double.infinity,
                    color: Colors.white38,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text(
                            'Sending comment...',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
