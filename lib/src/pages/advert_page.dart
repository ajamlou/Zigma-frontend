import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/components/carousel.dart';
import 'dart:async';
import 'package:zigma2/src/components/login_prompt.dart';
import 'package:zigma2/src/user.dart';

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
            getText("Författare: ", widget.data.authors),
            getText("Upplaga: ", widget.data.edition),
            getText("Skick: ", widget.data.condition),
            getText("ISBN: ", widget.data.isbn),
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
          color: Colors.white,
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
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black54,
                offset: Offset(1.0, 0.0),
                blurRadius: 8,
              )
            ]),
            margin: EdgeInsets.symmetric(horizontal: 65),
            child: SizedBox(
              height: 300,
              width: 100,
              child: GestureDetector(
                onTap: () {
                  carouselDialog();
                },
                child: Carousel(
                    images: widget.data.images,
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
        widget.data.price.toString() + ":-",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
          color: Color(0xFFECA72C),
        ),
      ),
    );
  }

  Widget getOwnerName() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 8, left: 10),
        child: FutureBuilder(
          future: getUser("username"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                "Denna bok säljs av " + snapshot.data.username + ".",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF373F51),
                ),
              );
            } else {
              return Text(
                "Denna bok säljs av " + "laddar...",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF373F51),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget getOwnerImage() {
    return FutureBuilder(
      future: getUser("has_picture,profile"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return !snapshot.data.hasPicture
              ? Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: GestureDetector(
                      onTap: () => getOwnerProfile(),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.transparent,
                      ),
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
                        child: GestureDetector(
                          onTap: () => getOwnerProfile(),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: FadeInImage.memoryNetwork(
                              fit: BoxFit.fitWidth,
                              placeholder: kTransparentImage,
                              image: DataProvider.of(context)
                                  .user
                                  .picUrl(snapshot.data.profile),
                            ),
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
        future: getUser("username,sold_books,bought_books"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
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
            );
          } else {
            return Text("Laddar... har sålt ... böcker och köpt ... böcker.");
          }
        },
      ),
    );
  }

  void profilePicDialog() {
    print("Im in show alertDialog");
    Dialog dialog = Dialog(
      insetAnimationCurve: Curves.decelerate,
      insetAnimationDuration: Duration(milliseconds: 500),
      backgroundColor: Colors.white,
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(DataProvider.of(context)
              .user
              .picUrl(DataProvider.of(context).user.user.profile)),
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
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
          child: Container(
            margin: EdgeInsets.only(top: 15),
            width: 300,
            child: RaisedButton(
              color: Color(0xFF3FBE7E),
              onPressed: () {
                developerDialog();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Expanded(
//                    child: Icon(
//                      Icons.chat_bubble,
//                      size: 30,
//                      color: Colors.white,
//                    ),
//                    flex: 2,
//                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getUser("username"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Text(
                              "Skicka ett meddelande till " +
                                  snapshot.data.username,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return Text(
                              "Skicka ett meddelande till " + "laddar...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ));
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
        .getUserById(widget.data.owner, fields);
    return userData;
  }

  void developerDialog() {
    Dialog dialog = Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: DataProvider.of(context).user.user == null
              ? LoginPrompt()
              : Container(
                  color: Colors.white,
                  child: Text(
                    "Denna knapp är ej implementerad :(",
                    style: TextStyle(fontSize: 45),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void carouselDialog() {
    Dialog dialog = Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Carousel(
            images: widget.data.images,
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

  Future<List> getOwnerAdvertLists() async {
    User tempUser = await getUser("adverts");
    List<Advert> ownerAdvertList = await DataProvider.of(context)
        .advertList
        .getAdvertsFromIds(tempUser.adverts);
    return ownerAdvertList;
  }

  void getOwnerProfile() async {
    DataProvider.of(context).loadingScreen.showLoadingDialog(context);
    User owner =
        await getUser("id,username,sold_books,bought_books,img_link,adverts");
    Navigator.of(context, rootNavigator: true).pop(null);
    DataProvider.of(context).routing.routeProfilePage(context, owner);
  }
}
