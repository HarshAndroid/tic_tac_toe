import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/screens/play_screen.dart';

import '../main.dart';

//this screen shows splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //hold this screen for 2 seconds and then move to next screen
    Future.delayed(const Duration(milliseconds: 2000), () {
      //exiting from full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const PlayScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          //game logo
          Positioned(
              top: mq.height * .25,
              width: mq.width * .5,
              left: mq.width * .25,
              child: Image.asset('images/icon.png')),

          //made in india text
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                'MADE WITH ❤️ BY HARSH',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, letterSpacing: .5, color: Colors.black87),
              ))
        ],
      ),
    );
  }
}
