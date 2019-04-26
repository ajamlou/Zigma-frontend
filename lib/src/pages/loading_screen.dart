import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'dart:async';



class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();

}
class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> rotation;
  Animation<double> text;
  int i = 0;
  Timer timer;
  List<String> loadingMessages = [
    "Fooing the bar...",
    "Burning the cats...",
    "Stacking the Widgets...",
    "Looking up your mom...",
    "Kevvakå fixar käk...",
    "Pillar med koden..."
  ];

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    controller.dispose();
    controller = null;
    super.dispose();
  }

  void disposeTimer(){
    timer.cancel();
    timer = null;
  }

  void routeAway(){
    DataProvider.of(context).routing.routeLandingPage(context);
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
      height: 100,
      width: 100,
      child: Scaffold(
        body: Container(
          color: Color(0xFFECE9DF),
          child: Column(
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
      ),
    );
  }
}
