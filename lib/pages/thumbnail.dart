import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  const ThumbnailRequest(
      {this.video,
      this.thumbnailPath,
      this.imageFormat,
      this.maxHeight,
      this.maxWidth,
      this.timeMs,
      this.quality});
}

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;
  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  //WidgetsFlutterBinding.ensureInitialized();
  Uint8List bytes;
  final Completer<ThumbnailResult> completer = Completer();
  if (r.thumbnailPath != null) {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: r.video,
        thumbnailPath: r.thumbnailPath,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality);

    print("thumbnail file is located: $thumbnailPath");

    final file = File(thumbnailPath);
    bytes = file.readAsBytesSync();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
        video: r.video,
        imageFormat: r.imageFormat,
        maxHeight: r.maxHeight,
        maxWidth: r.maxWidth,
        timeMs: r.timeMs,
        quality: r.quality);
  }

  int _imageDataSize = bytes.length;
  print("image size: $_imageDataSize");

  final _image = Image.memory(
    bytes,
    repeat: ImageRepeat.repeatX,
    fit: BoxFit.contain,
  );
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  final ThumbnailRequest thumbnailRequest;
  final double width;
  const GenThumbnailImage(
      {@required this.thumbnailRequest, @required this.width});

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final _image = snapshot.data.image;
          // final _width = snapshot.data.width;
          // final _height = snapshot.data.height;
          // final _dataSize = snapshot.data.dataSize;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: bottomContainerColor),
              color: bottomContainerColor,
            ),
            constraints: BoxConstraints.expand(width: widget.width),
            child: _image,
          );
        } else if (snapshot.hasError) {
          print('\n\n\n\n\n' + snapshot.error.toString());
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: bottomContainerColor),
              color: bottomContainerColor,
            ),
            padding: EdgeInsets.all(40),
            constraints: BoxConstraints.expand(width: 120),
            child: SizedBox(
              height: 10,
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3.0, color: bottomContainerColor),
              color: bottomContainerColor,
            ),
            padding: EdgeInsets.all(40),
            constraints: BoxConstraints.expand(width: widget.width),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
