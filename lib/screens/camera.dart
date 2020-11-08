import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vgo/pages/video_timer.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';

class CameraScreen extends StatefulWidget {
  @override
  CameraScreenState createState() => CameraScreenState();
}

String fileName;
bool isPick = false;
String videoPath;
File _file;
GlobalKey<ScaffoldState> _scaffold = GlobalKey();

class CameraScreenState extends State<CameraScreen>
    with AutomaticKeepAliveClientMixin {
  CameraController _camController;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldCameraKey =
      GlobalKey<ScaffoldState>();
  bool _isRecording = false;
  final _timerKey = GlobalKey<VideoTimerState>();
  int currentIndex = 2;
  final picker = ImagePicker();
  @override
  void initState() {
    _file = null;
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _camController = CameraController(_cameras[0], ResolutionPreset.medium);
    _camController.initialize().then((_) {
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
    _camController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_camController != null) {
      if (!_camController.value.isInitialized) {
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

    if (!_camController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      key: _scaffold,
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: mainTextColor,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: fadeTextColor,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          unselectedItemColor: fadeTextColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: FaIcon(Icons.home), label: ''),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.search), label: ''),
            BottomNavigationBarItem(icon: customIcon(), label: ''),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidHeart), label: ''),
            BottomNavigationBarItem(icon: FaIcon(Icons.person), label: '')
          ],
          currentIndex: currentIndex,
          onTap: (value) {
            if (value == 0) {
              Navigator.pushNamed(context, 'home');
            } else if (value == 1) {
              Navigator.pushNamed(context, 'search');
            } else if (value == 2) {
              Navigator.pushNamed(context, 'camera');
            } else if (value == 3) {
              Navigator.pushNamed(context, 'notification');
            } else if (value == 4) {
              Navigator.pushNamed(context, 'profile');
            }
          },
        ),
      ),
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
          Positioned(
            top: 24.0,
            left: 12.0,
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.syncAlt,
                color: Colors.white,
              ),
              onPressed: () {
                _onCameraSwitch();
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 32.0,
            child: VideoTimer(
              key: _timerKey,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomNavigationBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _camController.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _camController.value.aspectRatio,
              child: CameraPreview(_camController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: FaIcon(
              FontAwesomeIcons.folderOpen,
              color: Colors.white,
            ),
          ),
          CircleAvatar(
            radius: 32,
            backgroundColor: mainBgColor,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 28.0,
              child: IconButton(
                icon: FaIcon(
                  (_isRecording)
                      ? FontAwesomeIcons.stop
                      : FontAwesomeIcons.video,
                  size: 28.0,
                  color: mainBgColor,
                ),
                onPressed: () {
                  if (_isRecording) {
                    _onStopButtonPressed();
                  } else {
                    _onRecordButtonPressed();
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Video Library'),
                      onTap: () {
                        _videoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _videoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_camController.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_camController != null) {
      await _camController.dispose();
    }
    _camController =
        CameraController(cameraDescription, ResolutionPreset.medium);
    _camController.addListener(() {
      if (mounted) setState(() {});
      if (_camController.value.hasError) {
        showInSnackBar('Camera error ${_camController.value.errorDescription}');
      }
    });

    try {
      await _camController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        showInSnackBar('Recording video started');
      }
    });
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recorded to $videoPath');
    });
  }

  Future<String> _startVideoRecording() async {
    if (!_camController.value.isInitialized) {
      showInSnackBar('Please wait');
      return null;
    }

    // Do nothing if a recording is on progress
    if (_camController.value.isRecordingVideo) {
      setState(() {
        _isRecording = true;
      });
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await _camController.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!_camController.value.isRecordingVideo) {
      return null;
    }

    try {
      await _camController.stopVideoRecording().then((value) {
        setState(() {
          _isRecording = false;
        });
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldCameraKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: errorCardColor,
        content: Text(
          message.toString(),
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}

// Future _fileUploader() async {
//   if (_file != null) {
//     StorageReference storageReference =
//         FirebaseStorage.instance.ref().child('file1');
//     StorageUploadTask uploadTask = storageReference.putFile(_file);
//     await uploadTask.onComplete;
//     if (uploadTask.isSuccessful) {
//       _scaffold.currentState.showSnackBar(SnackBar(
//         backgroundColor: okCardColor,
//         content: Text(
//           'File Uploaded',
//           style: GoogleFonts.raleway(
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         duration: Duration(seconds: 3),
//       ));
//     }
//   } else {
//     _scaffold.currentState.showSnackBar(SnackBar(
//       backgroundColor: errorCardColor,
//       content: Text(
//         'No File',
//         style: GoogleFonts.raleway(
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//       duration: Duration(seconds: 3),
//     ));
//   }
// }
