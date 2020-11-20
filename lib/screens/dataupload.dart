import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoUploadData extends StatefulWidget {
  VideoUploadData({@required this.videoData});
  final File videoData;
  @override
  _VideoUploadDataState createState() => _VideoUploadDataState();
}

class _VideoUploadDataState extends State<VideoUploadData> {
    VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
    );
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child:FutureBuilder(
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
            ) ,
            ),
          ),
        ),
      ),
    );
}
