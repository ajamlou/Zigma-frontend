import 'package:flutter/material.dart';
import 'advert.dart';

class AdvertPage extends StatefulWidget {
  final Advert data;

  AdvertPage({this.data});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text(widget.data.bookTitle),
                )
              ],
            ),
          ),
          Image.asset('images/calc_book.png'),
          Text("Författare: " + widget.data.authors),
          Text("Pris: " + widget.data.price.toString()),
          Container(
            child: MaterialButton(
              onPressed: () {
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.chat_bubble),
                  Text("Skicka ett meddelande till " + widget.data.contactInfo)
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.face),
                Text(widget.data.contactInfo +
                    " har sålt 14 böcker och köpt 3 böcker.")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

