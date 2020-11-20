import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/pages/thumbnail.dart';
import 'package:vgo/pages/videos.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

ImageFormat _format = ImageFormat.JPEG;
int _quality = 50;
int _sizeH = 0;
int _sizeW = 0;
int _timeMs = 0;
String _tempDir;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
int index = 0;
bool gotVideos = false;
Map<dynamic, dynamic> videoData = Map();
Map<dynamic, dynamic> _futreImage = Map();
List<String> videopath = List();

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    super.dispose();
  }

  void getImages() {
    for (int i = 0; i < videopath.length; i++) {
      print(videopath[i]);
      setState(() {
        _futreImage.addAll({
          i: GenThumbnailImage(
              thumbnailRequest: ThumbnailRequest(
                  video: videopath[i].toString(),
                  thumbnailPath: _tempDir,
                  imageFormat: _format,
                  maxHeight: _sizeH,
                  maxWidth: _sizeW,
                  timeMs: _timeMs,
                  quality: _quality))
        });
      });
    }
  }

  void getVideoList() async {
    try {
      final userMail = _auth.currentUser.email;
      int counter = 0;
      try {
        await _firestore.collection("videos").get().then((value) {
          value.docs.forEach((element) {
            print(element.data()['url']);
            print('Enter');
            print(element.data()['url']);
            setState(
              () {
                videoData[counter] = new Map();
                videoData[counter].addAll({
                  'name': element.data()['name'],
                  'artist': element.data()['artist'],
                  'dp': element.data()['dp'],
                  'song': element.data()['song'],
                  'userId': element.data()['userId'],
                  'userMail': element.data()['userMail'],
                  'url': element.data()['url'],
                });
                videopath.add(element.data()['url'].toString());
              },
            );
            counter = counter + 1;
          });
          print(videopath);
        });
        getImages();
        setState(() {
          gotVideos = true;
        });
      } catch (e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: errorCardColor,
            content: Text(
              'An error occurred. Please try again later.',
              style: TextStyle(color: mainBgColor),
            ),
            duration: Duration(seconds: 3)));
      }
    } catch (e) {
      print(e);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: errorCardColor,
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: mainBgColor),
          ),
          duration: Duration(seconds: 3)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: bottomContainerColor,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: mainTextColor,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: mainBgColor,
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
              // changePage(value);
              if (value == 0) {
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
        body: Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: bottomContainerColor,
                appBar: TabBar(
                  indicatorColor: mainBgColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Container(
                          child: Text(
                        'Following',
                        style: GoogleFonts.josefinSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mainBgColor,
                        ),
                      )),
                    ),
                    Tab(
                      child: Container(
                          child: Text(
                        'For You',
                        style: GoogleFonts.josefinSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mainBgColor,
                        ),
                      )),
                    ),
                  ],
                ),
                body: TabBarView(
                  children: [
                    Container(
                      height: size.height,
                      color: bottomContainerColor,
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(
                            gotVideos ? videoData.length : 1, (index) {
                          return gotVideos
                              ? GestureDetector(
                                  child: Stack(
                                    children: [
                                      _futreImage[index],
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 5),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: Image.network(
                                                      'https://picsum.photos/id/${index + 50}/250/250',
                                                      height: 30.0,
                                                      width: 30.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Text(
                                                      followingName[index],
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: mainBgColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VideoPage(
                                                videoData: videoData)));
                                  },
                                )
                              : Container(
                                  color: bottomContainerColor,
                                );
                        }),
                      ),
                    ),
                    Container(
                      height: size.height,
                      color: bottomContainerColor,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(8, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VideoPage(
                                    videoData: null,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3.0,
                                  color: bottomContainerColor,
                                ),
                              ),
                              constraints: BoxConstraints.expand(height: 150),
                              child: Stack(
                                children: [
                                  VideoItem(
                                    forYouURL[index],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.network(
                                                  'https://picsum.photos/id/${index + 250}/250/250',
                                                  height: 30.0,
                                                  width: 30.0,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Text(
                                                  forYouName[index],
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: mainBgColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String url;

  VideoItem(this.url);
  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Key cellKey(VideoPlayerController _controller) =>
      Key('Controller-$_controller');
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        debugPrint("${info.visibleFraction} of my widget is visible");
        if (info.visibleFraction <= 0.50) {
          print(_controller);
          print('Paused');
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      key: cellKey(_controller),
      child: Center(
        child: _controller.value.initialized
            ? Stack(
                children: [
                  AspectRatio(
                    aspectRatio: MediaQuery.of(context).size.width *
                        2 /
                        MediaQuery.of(context).size.height,
                    child: VideoPlayer(_controller),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
