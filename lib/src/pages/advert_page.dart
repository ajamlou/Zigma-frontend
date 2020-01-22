import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/data/advert.dart';
import 'package:zigma2/src/components/carousel.dart';
import 'dart:async';
import 'package:zigma2/src/components/login_prompt.dart';
import 'package:zigma2/src/data/user.dart';

class AdvertPage extends StatefulWidget {
  final Advert advert;
  final List savedSearch;
  final String query;

  AdvertPage({this.advert, this.savedSearch, this.query});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  LoginPrompt loginPrompt = LoginPrompt();

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.pop(context, [widget.savedSearch, widget.query]),
            ),
            iconTheme: IconThemeData(color: Colors.white),
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
            getText("Författare: ", widget.advert.authors),
            getText("Upplaga: ", widget.advert.edition),
            getText("Skick: ", widget.advert.condition),
            getText("ISBN: ", widget.advert.isbn),
            getAdvertPrice(),
            getOwner(),
            getMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget getOwner() {
    return FutureBuilder(
      future: getUser(""),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            elevation: 3,
            child: ListTile(
              onTap: () {
                DataProvider.of(context)
                    .routing
                    .routeProfilePage(context, snapshot.data);
              },
              leading: !snapshot.data.hasPicture
                  ? Container(
                      width: 50,
                      height: 50,
                      child: FittedBox(
                        alignment: Alignment(0, 0),
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      width: 70,
                      child: Stack(
                        alignment: Alignment(0, 0),
                        children: <Widget>[
                          Center(child: CircularProgressIndicator()),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Container(
                              width: 50,
                              height: 50,
                              child: DataProvider.of(context).user.user !=
                                          null &&
                                      snapshot.data.profile ==
                                          DataProvider.of(context).user.user.id
                                  ? FittedBox(
                                      fit: BoxFit.cover,
                                      child: DataProvider.of(context)
                                          .user
                                          .user
                                          .profilePic)
                                  : FadeInImage.memoryNetwork(
                                      fit: BoxFit.fitWidth,
                                      placeholder: kTransparentImage,
                                      image: DataProvider.of(context)
                                          .user
                                          .picUrl(snapshot.data.profile),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
              title: Container(
                height: 100,
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Denna bok säljs av " + snapshot.data.username + ".",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFECA72C),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      snapshot.data.username +
                          " har sålt " +
                          snapshot.data.soldBooks.toString() +
                          " böcker och köpt " +
                          snapshot.data.boughtBooks.toString() +
                          " böcker.",
                      style: TextStyle(
                        color: Color(0xFF373F51),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFAEDBD3)),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget getAdvertTitle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment(0, 0),
      height: 50,
      child: Text(
        widget.advert.bookTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getAdvertPictures() {
    return widget.advert.images.length == 0
        ? Container(
            height: 300,
            child: Image.asset('images/placeholder_book.png'),
          )
        : Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(1.0, 0.0),
                  blurRadius: 8,
                )
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 65),
            child: SizedBox(
              height: 300,
              width: 100,
              child: GestureDetector(
                onTap: () {
                  carouselDialog();
                },
                child: Carousel(
                    images: widget.advert.images,
                    borderRadius: true,
                    noRadiusForIndicator: false),
              ),
            ),
          );
  }

  Widget getAdvertPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        widget.advert.price.toString() + ":-",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
          color: Color(0xFF3FBE7E),
        ),
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
          flex: 12,
          child: Container(
            margin: EdgeInsets.only(top: 25),
            width: 300,
            height: 40,
            child: RaisedButton(
              color: Color(0xFF3FBE7E),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder(
                      future: getUser(""),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              if (DataProvider.of(context).user.user != null) {
                                if (!DataProvider.of(context)
                                    .user
                                    .user
                                    .chatList
                                    .chattingUserList
                                    .contains(snapshot.data.username)) {
                                  DataProvider.of(context)
                                      .user
                                      .user
                                      .chatList
                                      .startNewChat(snapshot.data);
                                  DataProvider.of(context)
                                      .routing
                                      .routeChatPage(context, false);
                                }
                              } else {
                                loginPrompt.show(context);
                              }
                            },
                            child: Container(
                              child: Text(
                                "Skicka ett meddelande till " +
                                    snapshot.data.username,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFFAEDBD3),
                            ),
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
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
    );
  }

  Future<User> getUser(String fields) async {
    User userData = await DataProvider.of(context)
        .user
        .getUserById(widget.advert.owner, fields);
    return userData;
  }

  void carouselDialog() {
    Dialog dialog = Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Carousel(
            images: widget.advert.images,
            borderRadius: true,
            noRadiusForIndicator: false),
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
      return Container(
        margin: EdgeInsets.only(left: 25),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: leading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFECA72C),
            ),
            children: [
              TextSpan(
                text: content,
                style: TextStyle(
                  color: Color(0xFF373F51),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
