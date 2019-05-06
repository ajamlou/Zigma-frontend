import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _displayAds = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/advertPageBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(
              child: IconButton(
                color: Color(0xFFFFFFFF),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _profilePictureStyled(),
              _profileNameStyled(),
              _profileRatingStyled(),
              cardBuilder(),
              _profileInfoStyled(),
              //_profileMenusStyled(),
            ],
          ),
        ),
      ),
    );
  }

  void showLargerPicture() {}

  Widget _profilePictureStyled() {
    String userImageURI = DataProvider.of(context).user.getImage();
    return GestureDetector(
      onTap: showLargerPicture,
      child: Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Color(0xFF95453),
            radius: 75,
            backgroundImage: NetworkImage(
              userImageURI,
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileNameStyled() {
    return Center(
      child: RichText(
        text: TextSpan(
            // set the default style for the children TextSpans
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 30),
            children: [
              TextSpan(
                text: DataProvider.of(context).user.getUsername(),
                style: TextStyle(
                  color: Color(0xFFE36B1B),
                ),
              ),
            ]),
      ),
    );
  }

  Widget _profileRatingStyled() {
    return Center(
      child: RichText(
        text: TextSpan(
            // set the default style for the children TextSpans
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 20),
            children: [
              TextSpan(
                text: DataProvider.of(context).user.getEmail(),
                // Email tills vidare
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ]),
      ),
    );
  }

  Widget _profileInfoStyled() {
    return Scaffold();
  }

//  Widget _profileMenusStyled() {
//    return Column(
//      children: <Widget> [
//    Row(
//    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      children: <Widget>[
//        _displayAds ?
//        Container()
//            :
//        Container()
//      ],
//    ),
//    _displayAds ?
//    Container(
//    height: 250.0,
//    child: ListView.builder(
//    scrollDirection: Axis.vertical,
//    shrinkWrap: true,
//    itemCount: adList.length,
//    itemBuilder: cardBuilder(context, "ads"),)
//    ) :
//
//
//    cardBuilder("ads")
//        : cardBuilder("reviews");
//    ]
//    );
//  }

  Widget cardBuilder() {
    List<String> yo = [DataProvider.of(context).user.getImage()];
    Advert newAdvert = Advert("Den stora boken", 911, "Bok Larsson",
        "9876-1234", "026-164590", yo, "Good condition", "best edition");

    final makeListTile = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            height: 140.0,
            width: 110.0,
            child: FittedBox(fit: BoxFit.cover, child: Image.network(yo[0]))),
        title: Column(
          children: <Widget>[
            Text(newAdvert.bookTitle, style: TextStyle()),
            Text(newAdvert.authors, style: TextStyle()),
            Text(newAdvert.edition, style: TextStyle())
          ],
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

    return SizedBox(
      height: 150,
      child: Center(
        child: Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile,
          ),
        ),
      ),
    );
  }
}
