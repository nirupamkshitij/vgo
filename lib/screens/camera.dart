import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecordingMode = false;
  bool _isRecording = false;
  final picker = ImagePicker();
  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  _videoFromGallery() async {
    final pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
    );
    setState(
      () {
        if (pickedFile != null) {
          _file = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  _videoFromCamera() async {
    final pickedFile = await picker.getVideo(
      source: ImageSource.camera,
    );
    setState(
      () {
        if (pickedFile != null) {
          _file = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
          Positioned(
            top: 24.0,
            left: 12.0,
            child: IconButton(
              icon: Icon(
                Icons.switch_camera,
                color: Colors.white,
              ),
              onPressed: () {
                _onCameraSwitch();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.transparent,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.folderOpen,
                size: 28.0,
                color: Colors.white,
              ),
              onPressed: () {
                if (!_isRecordingMode) {
                  _captureImage();
                } else {
                  if (_isRecording) {
                    stopVideoRecording();
                  } else {
                    startVideoRecording();
                  }
                }
              },
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                Icons.videocam,
                size: 28.0,
                color: Colors.black,
              ),
              onPressed: () {
                if (!_isRecordingMode) {
                  _captureImage();
                } else {
                  if (_isRecording) {
                    stopVideoRecording();
                  } else {
                    startVideoRecording();
                  }
                }
              },
            ),
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller =
        CameraController(cameraDescription, ResolutionPreset.veryHigh);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized) {
      SystemSound.play(SystemSoundType.click);
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      print('path: $filePath');
      await _controller.takePicture(filePath);
      setState(() {});
    }
  }

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
//      videoPath = filePath;
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}

// import 'package:flutter/material.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
