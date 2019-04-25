import 'package:flutter/material.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/DataProvider.dart';

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          iconTheme: IconThemeData(color: Color(0xff96070a)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            widget.data.bookTitle,
            style: TextStyle(
              color: Color(0xff96070a),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          widget.data.images.length == 0
              ? Image.asset('images/calc_book.png')
              : Container(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.data.images.length,
                    itemBuilder: (BuildContext context, int index) =>
                        makeElement(index),
                  ),
                ),
          widget.data.authors == null
              ? Text("Det finns ingen författare till denna bok")
              : Text("Författare: " + widget.data.authors),
          Text("Pris: " + widget.data.price.toString()),
          Container(
            child: MaterialButton(
              onPressed: () {},
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

  Widget makeElement(int index) {
    print(widget.data.images[index]);
    return Center(
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.network(
          widget.data.images[index]
        ),
      ),
    );
  }
}
