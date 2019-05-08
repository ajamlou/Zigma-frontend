import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Advert> returnList;
  Future<List<Advert>> getUserAdverts(context) async {
    if(DataProvider.of(context).advertList.getUserAdvertList().length != 0){
      returnList = DataProvider.of(context).advertList.getUserAdvertList();
    }
    else{
     returnList = await DataProvider.of(context).advertList.getAdvertsFromIds(context);
    }
    print("IM IN GET USER ADVERTS");
    return returnList;
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _profilePictureStyled(),
              _profileNameStyled(),
              _profileRatingStyled(),
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: FutureBuilder(
                  future: getUserAdverts(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return cardBuilder(snapshot.data[index]);
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardBuilder(Advert a) {
    return MaterialButton(
      onPressed: () {
        DataProvider.of(context).routing.routeAdvertPage(context, a, false);
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(64, 75, 96, .9),
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              height: 90.0,
              width: 80.0,
              child: FittedBox(
                fit: BoxFit.cover,
                child: a.images.length == 0
                    ? Image.asset('images/placeholder_book.png')
                    : Image.network(a.images[0]),
              ),
            ),
            title: Column(
              children: <Widget>[
                Text(a.bookTitle, style: TextStyle()),
                Text(a.authors, style: TextStyle()),
                Text(a.edition, style: TextStyle())
              ],
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 30.0),
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
