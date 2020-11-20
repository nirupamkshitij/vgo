import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:video_player/video_player.dart';

class VideoUploadData extends StatefulWidget {
  VideoUploadData({@required this.videoData});
  final File videoData;
  @override
  _VideoUploadDataState createState() => _VideoUploadDataState();
}

class _VideoUploadDataState extends State<VideoUploadData> with RouteAware {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
            GestureDetector(
              onTap: () {
                // Navigator.of(context).pushNamed('search');
              },
              child: Padding(
                padding: EdgeInsets.only(
                  right: 15,
                  top: 10,
                ),
                child: Icon(Icons.star_rate_rounded),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('search');
              },
              child: Padding(
                padding: EdgeInsets.only(
                  right: 15,
                  top: 10,
                ),
                child: Icon(Icons.search),
              ),
            ),
          ]),
      body: Stack(
        children: [
          ClipRect(
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
          Padding(
            padding: EdgeInsets.only(
              top: 25,
              right: 25,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                onPressed: () {
                  // _dataUpdates();
                  // Navigator.popAndPushNamed(context, 'home');
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
          )
        ],
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
