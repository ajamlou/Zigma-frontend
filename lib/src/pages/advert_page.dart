import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';
import 'package:carousel_pro/carousel_pro.dart';

class AdvertPage extends StatefulWidget {
  final Advert data;

  AdvertPage({this.data});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/advertPageBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: AppBar(
            iconTheme: IconThemeData(color: Color(0xffECE9DF)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment(0, 0),
              height: 50,
              child: Text(
                widget.data.bookTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFECE9DF),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            widget.data.images.length == 0
                ? Image.asset('images/calc_book.png')
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 75),
                    height: 300,
                    child: Carousel(images: widget.data.images),
                  ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Författare: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff96070a),
                  ),
                ),
                Text(widget.data.authors)
              ],
            ),
            Text(
              widget.data.price.toString() + ":-",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0xff96070a),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.chat),
                Flexible(
                  child: Text(
                      "Skicka ett meddelande till : SÄTT NAMN PÅ ANVÄNDARE SOM ÄGER ANNONSEN HÄR",
                  textAlign: TextAlign.center,),
                ),
              ],
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
      ),
    );
  }

  Widget makeElement(int index) {
    print(widget.data.images[index]);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.5),
      child: Center(
        child: Stack(
          alignment: Alignment(0, 0),
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            FadeInImage.memoryNetwork(
              fit: BoxFit.fitWidth,
              placeholder: kTransparentImage,
              image: widget.data.images[index],
            ),
          ],
        ),
      ),
    );
  }
}
