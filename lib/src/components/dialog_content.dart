import 'package:flutter/material.dart';


class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  bool _isChecked = false;

  void setPrefs(){
    setState(() {
      _isChecked = !_isChecked;
    });
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
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            width: 80,
            height: 80,
            child: Image.asset("images/barcode.png"),
          ),
          Text("Visa inte igen", style: TextStyle(color: Colors.white),),
          Switch(
            inactiveThumbColor: Colors.white,
            activeColor: Colors.white,
            activeTrackColor: Color(0xFF3FBE7E),
            inactiveTrackColor: Color(0xFFDE5D5D),
            value: _isChecked,
            onChanged: (value) {
              setPrefs();
            },
          )
        ],
      ),
    );
  }
}
