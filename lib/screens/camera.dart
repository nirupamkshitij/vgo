// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:thumbnails/thumbnails.dart';
// import 'package:vgo/pages/video_timer.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({Key key}) : super(key: key);

//   @override
//   CameraScreenState createState() => CameraScreenState();
// }

// class CameraScreenState extends State<CameraScreen>
//     with AutomaticKeepAliveClientMixin {
//   CameraController _controller;
//   List<CameraDescription> _cameras;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isRecordingMode = false;
//   bool _isRecording = false;
//   final _timerKey = GlobalKey<VideoTimerState>();

//   @override
//   void initState() {
//     _initCamera();
//     super.initState();
//   }

//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     _controller = CameraController(_cameras[0], ResolutionPreset.medium);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     if (_controller != null) {
//       if (!_controller.value.isInitialized) {
//         return Container();
//       }
//     } else {
//       return const Center(
//         child: SizedBox(
//           width: 32,
//           height: 32,
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (!_controller.value.isInitialized) {
//       return Container();
//     }
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       key: _scaffoldKey,
//       extendBody: true,
//       body: Stack(
//         children: <Widget>[
//           _buildCameraPreview(),
//           Positioned(
//             top: 24.0,
//             left: 12.0,
//             child: IconButton(
//               icon: Icon(
//                 Icons.switch_camera,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 _onCameraSwitch();
//               },
//             ),
//           ),
//           if (_isRecordingMode)
//             Positioned(
//               left: 0,
//               right: 0,
//               top: 32.0,
//               child: VideoTimer(
//                 key: _timerKey,
//               ),
//             )
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildCameraPreview() {
//     final size = MediaQuery.of(context).size;
//     return ClipRect(
//       child: Container(
//         child: Transform.scale(
//           scale: _controller.value.aspectRatio / size.aspectRatio,
//           child: Center(
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: CameraPreview(_controller),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       color: Colors.transparent,
//       height: 100.0,
//       width: double.infinity,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           FutureBuilder(
//             future: getLastImage(),
//             builder: (context, snapshot) {
//               if (snapshot.data == null) {
//                 return Container(
//                   width: 40.0,
//                   height: 40.0,
//                 );
//               }
//               return GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   width: 40.0,
//                   height: 40.0,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(4.0),
//                     child: Image.file(
//                       snapshot.data,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           CircleAvatar(
//             backgroundColor: Colors.white,
//             radius: 28.0,
//             child: IconButton(
//               icon: Icon(
//                 (_isRecordingMode)
//                     ? (_isRecording)
//                         ? Icons.stop
//                         : Icons.videocam
//                     : Icons.camera_alt,
//                 size: 28.0,
//                 color: (_isRecording) ? Colors.red : Colors.black,
//               ),
//               onPressed: () {
//                 if (!_isRecordingMode) {
//                   _captureImage();
//                 } else {
//                   if (_isRecording) {
//                     stopVideoRecording();
//                   } else {
//                     startVideoRecording();
//                   }
//                 }
//               },
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               (_isRecordingMode) ? Icons.camera_alt : Icons.videocam,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isRecordingMode = !_isRecordingMode;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<FileSystemEntity> getLastImage() async {
//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/media';
//     final myDir = Directory(dirPath);
//     List<FileSystemEntity> _images;
//     _images = myDir.listSync(recursive: true, followLinks: false);
//     _images.sort((a, b) {
//       return b.path.compareTo(a.path);
//     });
//     var lastFile = _images[0];
//     var extension = path.extension(lastFile.path);
//     if (extension == '.jpeg') {
//       return lastFile;
//     } else {
//       String thumb = await Thumbnails.getThumbnail(
//           videoFile: lastFile.path, imageType: ThumbFormat.PNG, quality: 30);
//       return File(thumb);
//     }
//   }

//   Future<void> _onCameraSwitch() async {
//     final CameraDescription cameraDescription =
//         (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
//     if (_controller != null) {
//       await _controller.dispose();
//     }
//     _controller =
//         CameraController(cameraDescription, ResolutionPreset.veryHigh);
//     _controller.addListener(() {
//       if (mounted) setState(() {});
//       if (_controller.value.hasError) {
//         showInSnackBar('Camera error ${_controller.value.errorDescription}');
//       }
//     });

//     try {
//       await _controller.initialize();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _captureImage() async {
//     print('_captureImage');
//     if (_controller.value.isInitialized) {
//       SystemSound.play(SystemSoundType.click);
//       final Directory extDir = await getApplicationDocumentsDirectory();
//       final String dirPath = '${extDir.path}/media';
//       await Directory(dirPath).create(recursive: true);
//       final String filePath = '$dirPath/${_timestamp()}.jpeg';
//       print('path: $filePath');
//       await _controller.takePicture(filePath);
//       setState(() {});
//     }
//   }

//   Future<String> startVideoRecording() async {
//     print('startVideoRecording');
//     if (!_controller.value.isInitialized) {
//       return null;
//     }
//     setState(() {
//       _isRecording = true;
//     });
//     _timerKey.currentState.startTimer();

//     final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = '${extDir.path}/media';
//     await Directory(dirPath).create(recursive: true);
//     final String filePath = '$dirPath/${_timestamp()}.mp4';

//     if (_controller.value.isRecordingVideo) {
//       // A recording is already started, do nothing.
//       return null;
//     }

//     try {
// //      videoPath = filePath;
//       await _controller.startVideoRecording(filePath);
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//     return filePath;
//   }

//   Future<void> stopVideoRecording() async {
//     if (!_controller.value.isRecordingVideo) {
//       return null;
//     }
//     _timerKey.currentState.stopTimer();
//     setState(() {
//       _isRecording = false;
//     });

//     try {
//       await _controller.stopVideoRecording();
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

//   void _showCameraException(CameraException e) {
//     logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   void showInSnackBar(String message) {
//     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
//   }

//   void logError(String code, String message) =>
//       print('Error: $code\nError Message: $message');

//   @override
//   bool get wantKeepAlive => true;
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum CameraMode {
  PhotosMode,
  VideoMode,
}

Future main() async {
  final cameras = await availableCameras();

  runApp(CameraScreen(
    cameras: cameras,
  ));
}

class CameraScreen extends StatelessWidget {
  CameraScreen({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cameras: cameras),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, @required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CameraWidget(
            cameras: cameras,
          ),
        ),
      ),
    );
  }
}

class CameraWidget extends StatefulWidget {
  CameraWidget({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  final List<CameraDescription> cameras;

  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  CameraMode _cameraMode = CameraMode.PhotosMode;
  CameraDescription _currentSelectedCamera;
  String _recordedVideoSavePath;
  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.

    _currentSelectedCamera = widget.cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _currentSelectedCamera,
      // Define the resolution to use - from low - max (highest resolution available).
      ResolutionPreset.max,
      enableAudio: true,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (_cameraMode == CameraMode.PhotosMode)
                          _cameraControls(context),
                        if (_cameraMode == CameraMode.VideoMode)
                          _videoRecordingControls()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  CameraControls _cameraControls(BuildContext context) {
    return CameraControls(
      toggleCameraMode: _toggleCameraMode,
      takePicture: () => _capture(context),
      switchCameras: _switchCamera,
    );
  }

  VideoRecordingControls _videoRecordingControls() {
    return VideoRecordingControls(
      onSwitchCamerasBtnPressed: _switchCamera,
      onPauseRecodingBtnPressed: _pauseVideoRecording,
      onStopRecordingBtnPressed: _stopVideoRecording,
      onToggleCameraModeBtnPressed: _toggleCameraMode,
      onRecordVideoBtnPressed: _startVideoRecording,
      onResumeRecodingBtnPressed: _resumeVideoRecording,
      isRecordingPaused: _controller.value.isRecordingPaused,
      isRecording: _controller.value.isRecordingVideo,
    );
  }

  Future _switchCamera() async {
    // loop through all cameras and find current camera, then move to next
    for (var camera in widget.cameras) {
      if (camera.name == _currentSelectedCamera.name) {
        var x = widget.cameras.indexOf(camera);

        setState(() {
          // if the the last camera, move to first
          if (x == widget.cameras.length - 1) {
            _currentSelectedCamera = widget.cameras.first;
          } else {
            _currentSelectedCamera = widget.cameras[x + 1];
          }
        });

        if (_controller != null) {
          await _controller.dispose();
        }

        _controller = CameraController(
          _currentSelectedCamera,
          ResolutionPreset.max,
          enableAudio: true,
        );

        // If the controller is updated then update the UI.
        _controller.addListener(() {
          if (mounted) setState(() {});
          if (_controller.value.hasError) {
            print('Camera error ${_controller.value.errorDescription}');
          }
        });

        try {
          _controller.initialize();
        } on CameraException catch (e) {
          print(e);
        }
        break;
      }
    }
  }

  Future _startVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    // for iOS optimization
    _controller.prepareForVideoRecording();

    final Directory extDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final String dirPath = '${extDir.path}/Movies';
    await Directory(dirPath).create(recursive: true);
    _recordedVideoSavePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';

    try {
      await _controller.startVideoRecording(_recordedVideoSavePath);
    } on CameraException catch (e) {
      print(e);
      return;
    }

    setState(() {});
  }

  void _pauseVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.pauseVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }

    setState(() {});
  }

  void _resumeVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.resumeVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }

    setState(() {});
  }

  void _stopVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
    }

    setState(() {});
  }

  void _toggleCameraMode() {
    setState(() {
      _cameraMode = _cameraMode == CameraMode.PhotosMode
          ? CameraMode.VideoMode
          : CameraMode.PhotosMode;
    });
  }

  void _capture(BuildContext context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);

      await audioPlayer.play("shutter.wav");

      // attempt to save to gallery
      bool hasPermission =
          await PermissionsService().hasGalleryWritePermission();

      // request for permision if not given
      if (!hasPermission) {
        bool isGranted =
            await PermissionsService().requestPermissionToGallery();

        if (!isGranted) {
          _showMessage(
            context,
            "Permision Denied. Image was not saved to your Gallery!",
            color: Colors.red,
          );
          return;
        }
      }

      var image = await File(path).readAsBytes();

      var y = Uint8List.fromList(image);

      await ImageGallerySaver.saveImage(y);
    } catch (e) {
      _showMessage(
        context,
        "Error! ${e.toString()}",
        color: Colors.red,
      );
    }
  }

  /// Show snakbar message, you can customize text color for errors
  _showMessage(BuildContext context, String message,
      {Color color: Colors.white}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
