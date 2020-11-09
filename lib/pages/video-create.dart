import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vgo/screens/camera.dart';

class CreateVideo extends StatefulWidget {
  @override
  _CreateVideoState createState() => _CreateVideoState();
}

String path;

class _CreateVideoState extends State<CreateVideo> {
  CameraController _camController;
  Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _camController = CameraController(cameras[0], ResolutionPreset.medium);
    initializeControllerFuture = _camController.initialize();
  }

  @override
  void dispose() {
    _camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
