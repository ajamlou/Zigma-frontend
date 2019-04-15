import 'package:flutter/material.dart';

class AdvertPage extends StatefulWidget {
  final data;

  AdvertPage({this.data});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            Text(widget.data["Title"]),
          ],
        ),
        Image.asset('images/calc_book.png'),
        Text("Annonsen skapades: " + widget.data["created_at"]),
        Text("Pris" + widget.data["Price"]),
        Container(
          child: MaterialButton(
            onPressed: () {},
            child: Row(
              children: <Widget>[
                Icon(Icons.chat_bubble),
                Text("Skicka ett meddelande till " + widget.data["authors"])
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Image.asset('calc_book.png'),
              Text(widget.data["authors"] +
                  "har sålt 14 böcker och köpt 3 böcker.")
            ],
          ),
        ),
      ],
    );
  }
}
