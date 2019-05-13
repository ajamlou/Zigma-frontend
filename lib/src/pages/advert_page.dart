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
  //Build method
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'advert page',
      child: Container(
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
              getAdvertTitle(),
              SizedBox(
                height: 25,
              ),
              getAdvertPictures(),
              SizedBox(
                height: 30,
              ),
              getText("Författare: ", widget.data.authors),
              getText("Upplaga: ", widget.data.edition),
              getText(
                  "Skick: ",
                  DataProvider.of(context)
                      .advertList
                      .convertCondition(widget.data.condition)),
              getAdvertPrice(),
              getOwnerName(),
              Row(
                children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(top: 10.0),
              ),
                  getOwnerImage(),
                  getOwnerInformation(),
                ],
              ),
              getMessageButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAdvertTitle() {
    return Container(
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
    );
  }

  Widget getAdvertPictures() {
    return widget.data.images.length == 0
        ? Container(
            height: 300,
            child: Image.asset('images/placeholder_book.png'),
          )
        : Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent, width: 5)),
            margin: EdgeInsets.symmetric(horizontal: 75),
            height: 300,
            child: GestureDetector(
              onTap: () {
                carouselDialog();
              },
              child: Carousel(images: widget.data.images),
            ),
          );
  }

  Widget getAdvertPrice() {
    return Padding(
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
    );
  }

  Widget getOwnerName() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 8, left: 10),
        child: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                "Denna bok säljs av " + snapshot.data.username + ".",
                style: TextStyle(fontSize: 16),
              );
            } else {
              return Text(
                "Denna bok säljs av " + "laddar...",
                style: TextStyle(fontSize: 16),
              );
            }
          },
        ),
      ),
    );
  }

  Widget getOwnerImage() {
    return FutureBuilder(
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
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 50,
                          height: 50,
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
    );
  }

  Widget getOwnerInformation() {
    return Expanded(
      flex: 8,
      child: FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data.username +
                  " har sålt " +
                  snapshot.data.soldBooks.toString() +
                  " böcker och köpt " +
                  snapshot.data.boughtBooks.toString() +
                  " böcker.",
              textAlign: TextAlign.center,
            );
          } else {
            return Text("Laddar... har sålt ... böcker och köpt ... böcker.");
          }
        },
      ),
    );
  }

  Widget getMessageButton() {
    return Row(
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
    );
  }

  Future<dynamic> getUser() async {
    print(widget.data.owner.toString());
    var userData =
        await DataProvider.of(context).user.getUserById(widget.data.owner);
    return userData;
  }

  void carouselDialog() {
    print("Im in carousel alertDialog");
    Dialog dialog = Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Carousel(images: widget.data.images),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
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
