import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DialogContent extends StatefulWidget {
  bool isSelected;
  DialogContent({this.isSelected});
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  SharedPreferences prefs;

  Future<void> setTutorialPrefs() async {
    prefs.setBool("tutorial", widget.isSelected);
  }

  Future<bool> getTutorialPrefs() async {
    print(prefs.getBool("tutorial").toString());
    if (prefs.getBool("tutorial") != null) {
      return prefs.getBool("tutorial");
    } else
      return false;
  }

  void setPrefs() {
    setState(() {
      widget.isSelected = !widget.isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      widget.isSelected = await getTutorialPrefs();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    setTutorialPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
          Text(
            "Här kan du Scanna in din bok med hjälp av streckkoden som finns på baksidan av din bok",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            width: 80,
            height: 80,
            child: Image.asset("images/barcode.png"),
          ),
          Text(
            "Visa inte igen",
            style: TextStyle(color: Colors.white),
          ),
          Switch(
            inactiveThumbColor: Colors.white,
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF3FBE7E),
            inactiveTrackColor: Color(0xFFDE5D5D),
            value: widget.isSelected,
            onChanged: (value) {
              setPrefs();
            },
          )
        ],
      ),
    );
  }
}
