import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/pages/videodata.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:video_player/video_player.dart';

class VideoUploadData extends StatefulWidget {
  VideoUploadData({@required this.videoData});
  final File videoData;
  @override
  _VideoUploadDataState createState() => _VideoUploadDataState();
}

final _auth = FirebaseAuth.instance;

class _VideoUploadDataState extends State<VideoUploadData> with RouteAware {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  String userURL = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoData);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play().whenComplete(() {
        print('complete');
      });
    });
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)); //Subscribe it here
    super.didChangeDependencies();
  }

  @override
  void didPop() {
    print("didPop");
    super.didPop();
  }

  @override
  void didPopNext() {
    print("didPopNext");
    _controller.play();
    super.didPopNext();
  }

  @override
  void didPush() {
    print("didPush");
    super.didPush();
  }

  @override
  void didPushNext() {
    print("didPushNext");
    _controller.pause();
    super.didPushNext();
  }

  Future _fileUploader() async {
    if (widget.videoData != null) {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('' + widget.videoData.path.split('/').last);
      final UploadTask uploadTask = storageReference.putFile(widget.videoData);
      await uploadTask.whenComplete(() async {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: okCardColor,
          content: Text(
            'Video Uploaded',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
            ),
          ),
          duration: Duration(seconds: 3),
        ));
        userURL = await (storageReference.getDownloadURL());

        print(userURL);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => VideoDetailsData(
                docId: widget.videoData.path.split('/').last,
                url: userURL,
              ),
            ));
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: errorCardColor,
        content: Text(
          'No File',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
          ),
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: mainBgColor,
            size: 32,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: Icon(
                (Icons.arrow_back_ios),
                size: 28,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                right: 15,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  heroTag: "btn2",
                  backgroundColor: bottomContainerColor,
                  onPressed: () {
                    _fileUploader();
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: <Color>[
                          buttonBgColor,
                          buttonBgColor,
                        ],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
      body: ClipRect(
        child: Container(
          child: Transform.scale(
            scale: _controller.value.aspectRatio / size.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: size.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); //Don't forget to unsubscribe it!!!!!!
    super.dispose();
    _controller.dispose();
  }
}
