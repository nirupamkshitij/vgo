import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vgo/pages/thumbnail.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
ImageFormat _format = ImageFormat.JPEG;
int _quality = 50;
int _sizeH = 0;
int _sizeW = 0;
int _timeMs = 0;
String _tempDir;
final _firestore = FirebaseFirestore.instance;
int index = 0;
bool gotVideos = false;
Map<dynamic, dynamic> videoData = Map();
Map<dynamic, dynamic> _futreImage = Map();
Map<dynamic, dynamic> videopath = Map();
List<dynamic> tags = List();
Map<dynamic, dynamic> tagVideoData = Map();

class _SearchPageState extends State<SearchPage> {
  int _current = 0;
  int currentIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    videoData.clear();
    tagVideoData.clear();
    getTemporaryDirectory().then((d) => _tempDir = d.path);
    getVideoList();
    super.initState();
  }

  void getImages() {
    for (int i = 0; i < videopath.length; i++) {
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
                quality: _quality),
            width: MediaQuery.of(context).size.width / 2,
          )
        });
      });
    }
  }

  void getTagsList() async {
    try {
      await _firestore.collection("tags").doc('popular').get().then((value) {
        tags = value.data()['keys'];
      });
      int counter = 0;
      for (int i = 0; i < tags.length; i++) {
        counter = 0;
        tagVideoData[tags[i]] = new Map();
        for (int j = 0; j < videoData.length; j++) {
          if (videoData[j]['tags'].contains(tags[i])) {
            setState(
              () {
                tagVideoData[tags[i]][counter] = new Map();
                tagVideoData[tags[i]][counter].addAll({
                  'name': videoData[j]['name'],
                  'artist': videoData[j]['artist'],
                  'dp': videoData[j]['dp'],
                  'song': videoData[j]['song'],
                  'userId': videoData[j]['userId'],
                  'userMail': videoData[j]['userMail'],
                  'url': videoData[j]['url'],
                });
              },
            );
            counter = counter + 1;
          }
        }
      }
      print(tagVideoData);
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
      int counter = 0;
      try {
        await _firestore.collection("videos").get().then((value) {
          value.docs.forEach((element) {
            setState(
              () {
                videoData[counter] = new Map();
                videoData[counter].addAll({
                  'name': element.data()['name'],
                  'artist': element.data()['artist'],
                  'dp': element.data()['dp'],
                  'song': element.data()['song'],
                  'tags': element.data()['tags'],
                  'userId': element.data()['userId'],
                  'userMail': element.data()['userMail'],
                  'url': element.data()['url'],
                });
              },
            );
            counter = counter + 1;
          });
        });
        print(videoData.length);
        getTagsList();
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
    return SafeArea(
      child: Scaffold(
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
              if (value == 0) {
                Navigator.pushNamed(context, 'home');
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
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.09),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                            ),
                            items: imgList
                                .map((item) => Container(
                                      child: Center(
                                          child: Image.network(item,
                                              fit: BoxFit.cover, width: 1000)),
                                    ))
                                .toList(),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.2,
                            left: MediaQuery.of(context).size.width * 0.3,
                            right: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: imgList.map((url) {
                                int index = imgList.indexOf(url);
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? mainBgColor
                                        : lightFadeText,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // gotVideos
                    //     ? Container(
                    //         height: 300,
                    //         child: GridView.count(
                    //           crossAxisCount: 1,
                    //           children: List.generate(
                    //               gotVideos ? tags.length : 1, (index1) {
                    //             return gotVideos &&
                    //                     tagVideoData[tags[index1]].length > 0
                    //                 ? Column(
                    //                     children: [
                    //                       HeadingRow(
                    //                         title: tags[index1],
                    //                         count: double.parse(
                    //                             tagVideoData[tags[index1]]
                    //                                 .length
                    //                                 .toString()),
                    //                       ),
                    //                       Row(
                    //                         children: List.generate(
                    //                           tagVideoData[tags[index1]].length,
                    //                           (index) {
                    //                             print(
                    //                                 tagVideoData[tags[index1]]);
                    //                             return GestureDetector(
                    //                               child: Stack(
                    //                                 children: [
                    //                                   _futreImage[index],
                    //                                   Align(
                    //                                     alignment: Alignment
                    //                                         .bottomLeft,
                    //                                     child: Row(
                    //                                       mainAxisSize:
                    //                                           MainAxisSize.max,
                    //                                       crossAxisAlignment:
                    //                                           CrossAxisAlignment
                    //                                               .end,
                    //                                       children: [
                    //                                         Container(
                    //                                           padding: EdgeInsets
                    //                                               .only(
                    //                                                   left: 5,
                    //                                                   bottom:
                    //                                                       5),
                    //                                           child: Row(
                    //                                             children: [
                    //                                               ClipRRect(
                    //                                                 borderRadius:
                    //                                                     BorderRadius.circular(
                    //                                                         100.0),
                    //                                                 child: Image
                    //                                                     .network(
                    //                                                   tagVideoData[tags[index1]]
                    //                                                           [
                    //                                                           index]
                    //                                                       [
                    //                                                       'dp'],
                    //                                                   height:
                    //                                                       30.0,
                    //                                                   width:
                    //                                                       30.0,
                    //                                                 ),
                    //                                               ),
                    //                                               Padding(
                    //                                                 padding: EdgeInsets
                    //                                                     .only(
                    //                                                         left:
                    //                                                             10.0),
                    //                                                 child: Text(
                    //                                                   tagVideoData[tags[index1]]
                    //                                                           [
                    //                                                           index]
                    //                                                       [
                    //                                                       'userId'],
                    //                                                   style: GoogleFonts
                    //                                                       .raleway(
                    //                                                     fontSize:
                    //                                                         14,
                    //                                                     fontWeight:
                    //                                                         FontWeight.w700,
                    //                                                     color:
                    //                                                         mainBgColor,
                    //                                                   ),
                    //                                                 ),
                    //                                               ),
                    //                                             ],
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                               onTap: () {
                    //                                 Navigator.push(
                    //                                     context,
                    //                                     MaterialPageRoute(
                    //                                         builder: (context) =>
                    //                                             VideoPage(
                    //                                                 videoData:
                    //                                                     videoData)));
                    //                               },
                    //                             );
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   )
                    //                 : Container(
                    //                     color: bottomContainerColor,
                    //                   );
                    //           }),
                    //         ),
                    //       )
                    //     : CircularProgressIndicator(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingRow(
                          title: 'Camera',
                          count: 156.8,
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 100,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3.0,
                                        color: bottomContainerColor),
                                    color: bottomContainerColor,
                                  ),
                                  constraints:
                                      BoxConstraints.expand(width: 120),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 250}/540/810',
                                    repeat: ImageRepeat.repeatX,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeadingRow(
                          title: 'Traveller',
                          count: 12.8,
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 100,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3.0,
                                        color: bottomContainerColor),
                                    color: bottomContainerColor,
                                  ),
                                  constraints:
                                      BoxConstraints.expand(width: 120),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 350}/540/810',
                                    repeat: ImageRepeat.repeatX,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeadingRow(
                          title: 'Party',
                          count: 56.9,
                        ),
                        Container(
                          height: 200,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 100,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3.0,
                                        color: bottomContainerColor),
                                    color: bottomContainerColor,
                                  ),
                                  constraints:
                                      BoxConstraints.expand(width: 120),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 450}/540/810',
                                    repeat: ImageRepeat.repeatX,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 15,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: Colors.grey,
                      icon: FaIcon(
                        FontAwesomeIcons.search,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Search"),
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

class HeadingRow extends StatelessWidget {
  HeadingRow({@required this.title, @required this.count});
  final String title;
  final double count;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                backgroundColor: mainTextColor,
                child: Text(
                  '#',
                  style: GoogleFonts.raleway(fontSize: 32, color: mainBgColor),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.raleway(
                        color: mainBgColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    count.toString() + ' Videos',
                    style: GoogleFonts.raleway(
                        color: fadeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.55,
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => TagPage(
                  //       tagKey: title,
                  //     ),
                  //   ),
                  // );
                },
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 16,
                  color: mainBgColor,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class FloatAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return (FloatingSearchBar(
      trailing: CircleAvatar(
        child: Text("RD"),
      ),
      drawer: Drawer(
        child: Container(),
      ),
      onChanged: (String value) {},
      onTap: () {},
      decoration: InputDecoration.collapsed(
        hintText: "Search...",
      ),
      children: [],
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
