import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vgo/screens/camera.dart';
import 'package:vgo/utilities/constants.dart';

class CreateVideo extends StatefulWidget {
  @override
  _CreateVideoState createState() => _CreateVideoState();
}

String path;

class _CreateVideoState extends State<CreateVideo> {
  CameraController _camController;
  Future<void> initializeControllerFuture;
  bool isDisabled = false;
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
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: CameraPreview(_camController),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: !_camController.value.isRecordingVideo
                    ? RawMaterialButton(
                        onPressed: () async {
                          try {
                            await initializeControllerFuture;
                            path = join(
                                (await getApplicationDocumentsDirectory()).path,
                                '${DateTime.now()}.mp4');
                            setState(() {
                              _camController.startVideoRecording(path);
                              isDisabled = true;
                              isDisabled = !isDisabled;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      )
                    : null,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _camController.value.isRecordingVideo
                    ? RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            if (_camController.value.isRecordingVideo) {
                              _camController.stopVideoRecording();
                              print(path);
                              isDisabled = false;
                              isDisabled = !isDisabled;
                            }
                          });
                        },
                        child: Icon(
                          Icons.stop,
                          size: 50,
                          color: errorCardColor,
                        ),
                        padding: EdgeInsets.all(50),
                        shape: CircleBorder(),
                      )
                    : null,
              )
            ],
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
