import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/components/carousel.dart';
import 'dart:async';

class AdvertPage extends StatefulWidget {
  final Advert data;

  AdvertPage({this.data});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  Future<dynamic> getUser() async {
    print(widget.data.owner.toString());
    var userData =
        await DataProvider.of(context).user.getUserById(widget.data.owner);
    return userData;
  }

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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            widget.data.images.length == 0
                ? Container(
                    height: 300,
                    child: Image.asset('images/calc_book.png'),
                  )
                : Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.lightBlueAccent, width: 5)),
                    margin: EdgeInsets.symmetric(horizontal: 75),
                    height: 300,
                    child: Carousel(images: widget.data.images),
                  ),
            SizedBox(
              height: 30,
            ),
            getText("Författare: ", widget.data.authors),
            getText("Upplaga: ", widget.data.edition),
            getText("Skick: ", widget.data.condition),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.data.price.toString() + ":-",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xff96070a),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 10),
              child: FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "Denna bok säljs av " + snapshot.data.username + ".",
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Text(
                      "Denna bok säljs av " + "laddar...",
                      style: TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ),
            Row(
              children: <Widget>[
                FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.image == null
                          ? Expanded(
                              flex: 2,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: Stack(
                                alignment: Alignment(0, 0),
                                children: <Widget>[
                                  Center(child: CircularProgressIndicator()),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: FadeInImage.memoryNetwork(
                                        fit: BoxFit.fitWidth,
                                        placeholder: kTransparentImage,
                                        image: snapshot.data.image,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    } else {
                      return Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.none,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                Expanded(
                  flex: 8,
                  child: FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.username +
                              " har sålt 0 böcker och köpt 3 böcker.",
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return Text(
                            "Laddar... har sålt 0 böcker och köpt 3 böcker.");
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 6,
                  child: RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Icon(
                            Icons.chat_bubble,
                            size: 30,
                            color: Color(0xff96070a),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: getUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "Skicka ett meddelande till " +
                                      snapshot.data.username,
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return Text(
                                  "Skicka ett meddelande till " + "laddar...",
                                  textAlign: TextAlign.center,
                                );
                              }
                            },
                          ),
                          flex: 8,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getText(leading, content) {
    if (content == "") {
      return SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: leading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff96070a),
          ),
          children: [
            TextSpan(
              text: content,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }
  }
}
