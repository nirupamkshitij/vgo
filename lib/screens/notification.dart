import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:vgo/widgets/bottomnavbar.dart';

bool hasNotifications = false;
bool hasMessages = false;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
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
                  // changePage(value);
                  if (value == 0) {
                    Navigator.pushNamed(context, 'home');
                  } else if (value == 1) {
                    Navigator.pushNamed(context, 'search');
                  } else if (value == 2) {
                    Navigator.pushNamed(context, 'camera');
                  } else if (value == 4) {
                    Navigator.pushNamed(context, 'profile');
                  }
                },
              ),
            ),
            appBar: TabBar(
              labelColor: bottomContainerColor,
              unselectedLabelColor: bottomContainerColor,
              indicatorColor: mainBgColor,
              tabs: [
                Tab(
                  child: Container(
                    child: Text(
                      'Notifications',
                      style: GoogleFonts.raleway(
                          color: mainBgColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: Text(
                      'Messages',
                      style: GoogleFonts.raleway(
                          color: mainBgColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                hasNotifications
                    ? ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 250}/80/80',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                                trailing: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 100}/80/80',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                                title: Text(
                                  "Lorem ipsum",
                                  style: GoogleFonts.raleway(
                                      color: mainBgColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "Notification received ",
                                      style: GoogleFonts.raleway(
                                          color: lightFadeText,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "5 mins ago",
                                      style: GoogleFonts.raleway(
                                          color: fadeTextColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            hasNotifications = true;
                          });
                        },
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/nomess.png',
                                fit: BoxFit.fitWidth,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Column(
                                  children: [
                                    Text(
                                      'No notifications yet',
                                      style: GoogleFonts.raleway(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: mainBgColor,
                                      ),
                                    ),
                                    Text(
                                      '''No a new chat with your friends now''',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: lightFadeText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                hasMessages
                    ? ListView.builder(
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    'https://picsum.photos/id/${index + 250}/80/80',
                                    width: 45,
                                    height: 45,
                                  ),
                                ),
                                title: Text(
                                  "Lorem ipsum",
                                  style: GoogleFonts.raleway(
                                      color: mainBgColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "Message request ",
                                      style: GoogleFonts.raleway(
                                          color: lightFadeText,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "5 mins ago",
                                      style: GoogleFonts.raleway(
                                          color: fadeTextColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            hasMessages = true;
                          });
                        },
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/nomess.png',
                                fit: BoxFit.fitWidth,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.1),
                                child: Column(
                                  children: [
                                    Text(
                                      'No messages yet',
                                      style: GoogleFonts.raleway(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: mainBgColor,
                                      ),
                                    ),
                                    Text(
                                      '''No a new chat with your friends now''',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: lightFadeText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
