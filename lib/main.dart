import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgo/screens/splash.dart';
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
        // 'login': (context) => Login(),
        // 'signin': (context) => SignIn(),
        // 'navigation': (context) => NavigationScreen(),
        // 'notification': (context) => NotificationScreen(),
        // 'profile': (context) => ProfileScreen(),
        // 'search': (context) => SearchPage(),
        // 'camera': (context) => CameraScreen(),
        // 'home': (context) => HomeScreen(),
        // 'signin1': (context) => SignInData(),
        // 'terms': (context) => Terms(),
        // 'email': (context) => EmailLogin(),
      },
    );
  }
}
