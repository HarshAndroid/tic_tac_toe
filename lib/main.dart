import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper/shared_pref.dart';
import 'screens/splash_screen.dart';

//for storing dynamic height & width of device
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //for opening app in full-screen mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting preferred orientation to portrait
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) {
    //initializing shared preferences
    SharedPref.initPref();

    //run app
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: const SplashScreen(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 1,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 19))),
    );
  }
}
