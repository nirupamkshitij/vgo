import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vgo/pages/thumbnail.dart';
import 'package:vgo/pages/videos.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';
import 'package:vgo/screens/userinfo.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

List likedList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQQ2Hva9nycXUkfPZdJYDAwi6GhQUkWtAXh9w&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRAJfFfECKakFLGuS6_auGjBfMtNb9L98oAfQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSOJIeWMZeatENYCwL2vSQmRLNYXDTAfMUC_w&usqp=CAU',
  'https://images.shaadisaga.com/shaadisaga_production/photos/pictures/000/683/048/new_large/aanal_savaliya.jpg?1548750168',
  'https://images.shaadisaga.com/shaadisaga_production/photos/pictures/000/683/049/new_large/andrew_koe_studio.jpg?1548750174'
];
String username = '';
String userId = '';
String userBio = '';
String userURL = '';
int followers = 0;
int following = 0;
int liked = 0;
bool isReady = false;
bool gotVideos = false;
ImageFormat _format = ImageFormat.JPEG;
int _quality = 50;
int _sizeH = 0;
int _sizeW = 0;
int _timeMs = 0;
String _tempDir;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
Map<dynamic, dynamic> videoData = Map();
Map<dynamic, dynamic> _futreImage = Map();
List<String> videopath = List();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    videoData.clear();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    getUserMail();
    getVideoList();
    super.initState();
  }

  void getUserMail() async {
    try {
      final userMail = _auth.currentUser.email;
      try {
        await _firestore.collection("user").doc(userMail).get().then((value) {
          setState(() {
            username = value.data()['name'];
            userBio = value.data()['userBio'];
            userId = value.data()['userId'];
            followers = value.data()['follower'];
            following = value.data()['following'].length;
            liked = value.data()['liked'];
            try {
              userURL = value.data()['dpURl'];
            } catch (e) {
              userURL = null;
            }
            isReady = true;

            print('Got Data');
          });
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

  void getVideoList() async {
    try {
      final userMail = _auth.currentUser.email;
      int counter = 0;
      try {
        await _firestore.collection("videos").get().then((value) {
          value.docs.forEach((element) {
            print(element.data()['url']);
            if (element.data()['userMail'] == userMail) {
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
            }
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

  void getImages() {
    for (int i = 0; i < videopath.length; i++) {
      print(videopath[i]);
      setState(
        () {
          _futreImage.addAll(
            {
              i: GenThumbnailImage(
                thumbnailRequest: ThumbnailRequest(
                    video: videopath[i].toString(),
                    thumbnailPath: _tempDir,
                    imageFormat: _format,
                    maxHeight: _sizeH,
                    maxWidth: _sizeW,
                    timeMs: _timeMs,
                    quality: _quality),
                width: 120,
              )
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (isReady) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(right: width * 0.00, top: 10),
            child: FloatingActionButton(
              mini: true,
              heroTag: "btn1",
              elevation: 0,
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: FaIcon(
                FontAwesomeIcons.ellipsisV,
                size: 18.0,
                color: mainBgColor,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          endDrawer: EndDrawer(),
          endDrawerEnableOpenDragGesture: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          backgroundColor: mainTextColor,
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
                  Navigator.pushNamed(context, 'home');
                } else if (value == 1) {
                  Navigator.pushNamed(context, 'search');
                } else if (value == 2) {
                  Navigator.pushNamed(context, 'camera');
                } else if (value == 3) {
                  Navigator.pushNamed(context, 'notification');
                }
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: NetworkImage(userURL),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.035, left: 25),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              userURL,
                              height: 80.0,
                              width: 80.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 60,
                              top: 60,
                            ),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: errorCardColor,
                              child: Text(
                                'V',
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: mainBgColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.0185, left: 25),
                      child: Text(
                        username,
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: mainBgColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 28),
                      child: Text(
                        userId,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: lightFadeText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 28),
                      child: Text(
                        userBio,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mainBgColor,
                        ),
                      ),
                    ),
                    Divider(
                      color: fadeTextColor,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                children: [
                                  Text(
                                    liked.toString(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: mainBgColor,
                                    ),
                                  ),
                                  Text(
                                    'Liked',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: lightFadeText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                children: [
                                  Text(
                                    followers.toString(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: mainBgColor,
                                    ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: lightFadeText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                children: [
                                  Text(
                                    following.toString(),
                                    style: GoogleFonts.raleway(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: mainBgColor,
                                    ),
                                  ),
                                  Text(
                                    'Followings',
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: lightFadeText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.340),
                child: Tabbar(),
              )
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(right: width * 0.00, top: 10),
            child: FloatingActionButton(
              mini: true,
              heroTag: "btn1",
              elevation: 0,
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
              child: FaIcon(
                FontAwesomeIcons.ellipsisV,
                size: 18.0,
                color: mainBgColor,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          endDrawer: EndDrawer(),
          endDrawerEnableOpenDragGesture: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          backgroundColor: mainTextColor,
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
                  Navigator.pushNamed(context, 'home');
                } else if (value == 1) {
                  Navigator.pushNamed(context, 'search');
                } else if (value == 2) {
                  Navigator.pushNamed(context, 'camera');
                } else if (value == 3) {
                  Navigator.pushNamed(context, 'notification');
                }
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                decoration: BoxDecoration(
                  color: bottomContainerColor,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(buttonBgColor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.340),
                child: Tabbar(),
              )
            ],
          ),
        ),
      );
    }
  }
}

class EndDrawer extends StatelessWidget {
  const EndDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: bottomContainerColor,
        child: ListView(
          children: [
            ListTile(
              title: Text(
                username,
                style: GoogleFonts.raleway(
                    color: mainBgColor, fontWeight: FontWeight.w700),
              ),
            ),
            GestureDrawer(
              route: 'null',
              iconData: FontAwesomeIcons.externalLinkAlt,
              textData: 'Share Profile',
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileInfo(),
                  ),
                );
              },
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.cogs,
                  size: 18,
                  color: mainBgColor,
                ),
                title: Text(
                  'Settings',
                  style: GoogleFonts.raleway(
                      color: mainBgColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            GestureDrawer(
              route: 'terms',
              iconData: FontAwesomeIcons.info,
              textData: 'Help',
            ),
            GestureDrawer(
              route: 'terms',
              iconData: FontAwesomeIcons.asterisk,
              textData: 'Terms of Use',
            ),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                print("USER SIGNED OUT");
              },
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  size: 18,
                  color: mainBgColor,
                ),
                title: Text(
                  'Log Out',
                  style: GoogleFonts.raleway(
                      color: mainBgColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GestureDrawer extends StatelessWidget {
  const GestureDrawer({
    @required this.route,
    @required this.iconData,
    @required this.textData,
  });
  final String route;
  final IconData iconData;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: ListTile(
        leading: FaIcon(
          iconData,
          size: 18,
          color: mainBgColor,
        ),
        title: Text(
          textData,
          style: GoogleFonts.raleway(
              color: mainBgColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: bottomContainerColor,
          appBar: TabBar(
            labelColor: bottomContainerColor,
            unselectedLabelColor: bottomContainerColor,
            indicatorColor: mainBgColor,
            tabs: [
              Tab(
                child: Container(
                  child: FaIcon(
                    FontAwesomeIcons.list,
                    color: mainBgColor,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: FaIcon(
                    FontAwesomeIcons.heart,
                    color: mainBgColor,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: FaIcon(
                    FontAwesomeIcons.bookmark,
                    color: mainBgColor,
                  ),
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                color: bottomContainerColor,
                child: GridView.count(
                  crossAxisCount: 3,
                  children:
                      List.generate(gotVideos ? videoData.length : 1, (index) {
                    return gotVideos
                        ? GestureDetector(
                            child: _futreImage[index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPage(videoData: videoData)));
                            },
                          )
                        : Container(
                            color: bottomContainerColor,
                          );
                  }),
                ),
              ),
              Container(
                color: bottomContainerColor,
                child: GridView.count(
                  crossAxisCount: 3,
                  children:
                      List.generate(gotVideos ? videoData.length : 1, (index) {
                    return gotVideos
                        ? _futreImage[index]
                        : Container(
                            color: bottomContainerColor,
                          );
                  }),
                ),
              ),
              Container(
                color: bottomContainerColor,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(5, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3.0,
                          color: bottomContainerColor,
                        ),
                        color: bottomContainerColor,
                      ),
                      constraints: BoxConstraints.expand(height: 100),
                      child: Image.network(
                        likedList[index],
                        repeat: ImageRepeat.repeatX,
                        fit: BoxFit.contain,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
