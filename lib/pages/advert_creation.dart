import 'package:flutter/material.dart';

class advertCreation extends StatefulWidget {
  State createState() => new advertCreationState();
}

class advertCreationState extends State<advertCreation> {
  final GlobalKey<FormState> _advertKey =  GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFECE9DF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Form(
            key: _advertKey,
            child: Column(
              children: <Widget> [
                Text(), //Här ska information om vad som ska ingå i textfältet skrivas
                TextFormField(

            ),// Här ska textfältet kontrolleras
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}