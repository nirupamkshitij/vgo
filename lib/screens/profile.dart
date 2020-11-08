import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';

List imageList = [
  'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1516239482977-b550ba7253f2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1527082395-e939b847da0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT4FUJT4I5cjHAADrJGB6KT0Br5FDQ8KOtwtQ&usqp=CAU'
];
List likedList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQQ2Hva9nycXUkfPZdJYDAwi6GhQUkWtAXh9w&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRAJfFfECKakFLGuS6_auGjBfMtNb9L98oAfQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSOJIeWMZeatENYCwL2vSQmRLNYXDTAfMUC_w&usqp=CAU',
  'https://images.shaadisaga.com/shaadisaga_production/photos/pictures/000/683/048/new_large/aanal_savaliya.jpg?1548750168',
  'https://images.shaadisaga.com/shaadisaga_production/photos/pictures/000/683/049/new_large/andrew_koe_studio.jpg?1548750174'
];
final String username = '';
final String userId = '';
final String userBio = '';
final String userURL = '';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentIndex = 4;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                  image: AssetImage('images/profile.png'),
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
                          child: Image.asset(
                            'images/profile.png',
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
                      'No bio yet',
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
                                  '1.2m',
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
                                  '12.8k',
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
                                  '1.9k',
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
                'TIm Cooks',
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
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => UserInfo(
              //         userMail: 'emailid@gmail.com',
              //         userName: username,
              //         userNumber: 8902377381,
              //         userImage: 'images/profile.png',
              //         userId: userId,
              //       ),
              //     ),
              //   );
              // },
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
            GestureDrawer(
              route: 'login',
              iconData: FontAwesomeIcons.signOutAlt,
              textData: 'Log Out',
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

class Tabbar extends StatelessWidget {
  const Tabbar({
    Key key,
  }) : super(key: key);

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
                  children: List.generate(7, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3.0,
                          color: bottomContainerColor,
                        ),
                      ),
                      constraints: BoxConstraints.expand(height: 100),
                      child: Image.network(
                        imageList[index],
                        repeat: ImageRepeat.repeatX,
                        fit: BoxFit.contain,
                      ),
                    );
                  }),
                ),
              ),
              Container(
                color: bottomContainerColor,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(7, (index) {
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
                        imageList[index],
                        repeat: ImageRepeat.repeatX,
                        fit: BoxFit.contain,
                      ),
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
