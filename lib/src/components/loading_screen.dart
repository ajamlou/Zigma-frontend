import 'package:flutter/material.dart';
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> rotation;
  Animation<double> text;
  int i = 0;
  Timer timer;
  List<String> loadingMessages = [
    "Hämtar databasen...",
    "Lägger ihop komponenterna...",
    "Smörjer alla kugghjul...",
    "Läser lite böcker...",
    "Bränner lite katter...",
  ];

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    controller.dispose();
    controller = null;
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 1500), (Timer t) {
      if (i == 4) {
        setState(() {
          i = 0;
        });
      }
      setState(() {
        i++;
      });
      print(i.toString());
    });
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.elasticInOut)));
    controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      height: 100,
      width: 100,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: RotationTransition(
                turns: rotation,
                child: Container(
                  width: 50,
                  height: 50,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                child: Text(
              loadingMessages[i],
              style: TextStyle(fontSize: 15),
            ))
          ],
        ),
      ),
    );
  }
}

class LoadingDialog {
  void show(context) {
    AlertDialog dialog = AlertDialog(
        title: Text(
          "Laddar...",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF373F51),
          ),
          textAlign: TextAlign.center,
        ),
        content: LoadingScreen());
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }
}
