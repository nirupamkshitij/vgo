import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:tik_tok_demo/utilities/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  VideoPage();
  @override
  _VideoPageState createState() => _VideoPageState();
}

final _controller = ScrollController();
int keyValue = 0;

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: bottomContainerColor,
      body: InViewNotifierList(
        physics: CustomScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.vertical,
        initialInViewIds: ['0'],
        isInViewPortCondition:
            (double deltaTop, double deltaBottom, double viewPortDimension) {
          return deltaTop < (0.6 * viewPortDimension) &&
              deltaBottom > (0.4 * viewPortDimension);
        },
        itemCount: 8,
        builder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InViewNotifierWidget(
                  id: '$index',
                  builder: (BuildContext context, bool isInView, Widget child) {
                    return VideoCustom(
                      play: isInView,
                      index: index,
                      size: size,
                    );
                  },
                );
              },
              scrollDirection: Axis.vertical,
              itemCount: 8,
            ),
          );
        },
      ),
    ));
  }
}

class VideoCustom extends StatefulWidget {
  const VideoCustom({
    @required this.size,
    this.index,
    @required this.play,
  });
  final bool play;
  final Size size;
  final int index;
  @override
  _VideoCustomState createState() => _VideoCustomState();
}

class _VideoCustomState extends State<VideoCustom>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      followingURL[widget.index],
    );
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play().whenComplete(() {
        print('complete');
      });
    });
  }

  @override
  void didUpdateWidget(VideoCustom oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: widget.size.width,
            height: widget.size.height,
            decoration: BoxDecoration(color: bottomContainerColor),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: widget.size.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, bottom: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                followingName[widget.index],
                                style: GoogleFonts.raleway(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: mainBgColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: FlatButton(
                                  shape: StadiumBorder(),
                                  onPressed: () {},
                                  child: Text('Follow'),
                                  color: okCardColor,
                                ),
                              )
                            ],
                          ),
                          Text(
                            followingFileName[widget.index],
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: mainBgColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.music,
                                color: mainBgColor,
                                size: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Song - Artist",
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: mainBgColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 40,
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 0.80),
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.network(
                            followingImageURL[widget.index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        left: 28,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Text(
                            "v",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: mainBgColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.solidHeart,
                          size: 38, color: mainBgColor),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "21",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainBgColor),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        size: 38,
                        color: mainBgColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "45",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainBgColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.share,
                    size: 38,
                    color: mainBgColor,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    return Transform.rotate(
                        angle: _animationController.value * 6.3, child: child);
                  },
                  animation: _animationController,
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.network(
                            followingImageURL[widget.index],
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      friction: 0.1, // <--- HERE
      tolerance: tolerance,
    );
  }
}
