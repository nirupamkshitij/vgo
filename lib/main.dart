import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgo/screens/camera.dart';
import 'package:vgo/screens/emaillogin.dart';
import 'package:vgo/screens/home.dart';
import 'package:vgo/screens/login.dart';
import 'package:vgo/screens/navigation.dart';
import 'package:vgo/screens/notification.dart';
import 'package:vgo/screens/profile.dart';
import 'package:vgo/screens/search.dart';
import 'package:vgo/screens/signin.dart';
import 'package:vgo/screens/signindata.dart';
import 'package:vgo/screens/splash.dart';
import 'package:vgo/screens/terms.dart';
// import 'package:tik_tok_demo/screens/camera.dart';
// import 'package:tik_tok_demo/screens/emaillogin.dart';
// import 'package:tik_tok_demo/screens/home.dart';
// import 'package:tik_tok_demo/screens/login.dart';
// import 'package:tik_tok_demo/screens/navigation.dart';
// import 'package:tik_tok_demo/screens/notification.dart';
// import 'package:tik_tok_demo/screens/profile.dart';
// import 'package:tik_tok_demo/screens/search.dart';
// import 'package:tik_tok_demo/screens/signin.dart';
// import 'package:tik_tok_demo/screens/signindata.dart';
// import 'package:tik_tok_demo/screens/terms.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MainApp());
  });
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'splash': (context) => SplashScreen(),
        'navigation': (context) => NavigationScreen(),
        'login': (context) => Login(),
        'profile': (context) => ProfileScreen(),
        'email': (context) => EmailLogin(),
        'home': (context) => HomeScreen(),
        'signin1': (context) => SignInData(),
        'signin': (context) => SignIn(),
        'search': (context) => SearchPage(),
        'terms': (context) => Terms(),
        'notification': (context) => NotificationScreen(),
        'camera': (context) => CameraExampleHome(),
        // 'signin1': (context) => SignInData(),
      },
    );
  }
}
