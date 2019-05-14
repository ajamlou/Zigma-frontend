import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final int initialPage = 0;
  List<dynamic> returnList;
  int stateButtonIndex = initialPage;
  final controller = PageController(
    initialPage: initialPage,
  );

  Future<dynamic> getUserBuyingAdverts(context) async {
    if (DataProvider.of(context).advertList.userListBuying.length != 0) {
      returnList = DataProvider.of(context).advertList.userListBuying;
    } else {
      returnList = await DataProvider.of(context)
          .advertList
          .getSpecificAdverts("B", DataProvider.of(context).user.user.id, "A");
      if (returnList.length == 0) {
        return noAdverts(context);
      }
    }
    return returnList;
  }

  Future<dynamic> getUserSellingAdverts(context) async {
    if (DataProvider.of(context).advertList.userListSelling.length != 0) {
      returnList = DataProvider.of(context).advertList.userListSelling;
    } else {
      returnList = await DataProvider.of(context)
          .advertList
          .getSpecificAdverts("S", DataProvider.of(context).user.user.id, "A");
      if (returnList.length == 0) {
        return noAdverts(context);
      }
    }
    return returnList;
  }

  void pageChanged(int index) {
    setState(() {
      stateButtonIndex = index;
    });
  }

  void buttonChangePage(int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
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
            leading: IconButton(
              color: Color(0xFFFFFFFF),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  stateButtons("Säljer", 0),
                  stateButtons("Köper", 1),
                  stateButtons("Alla", 2)
                ],
              ),
              Flexible(
                child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    pageChanged(index);
                  },
                  children: <Widget>[
                    getAdverts(
                        getUserSellingAdverts(context)),
                    getAdverts(getUserBuyingAdverts(context)),
                    getAdverts(DataProvider.of(context).advertList.getCombinedUserLists()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stateButtons(String text, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment(0, 0),
      width: 100,
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.red),
          color: index == stateButtonIndex ? Colors.red : Colors.white),
      child: MaterialButton(
        onPressed: () {
          buttonChangePage(index);
        },
        child: Text(text),
      ),
    );
  }

  Widget getAdverts(Future adverts) {
    return FutureBuilder(
      future: adverts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data is List ? snapshot.data.length : 1,
            itemBuilder: (context, index) {
              if (snapshot.data is List) {
                return cardBuilder(snapshot.data[index]);
              } else {
                return snapshot.data;
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget cardBuilder(Advert a) {
    return MaterialButton(
      onPressed: () {
        DataProvider.of(context).routing.routeUserAdvertPage(context, a, false);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 8),
                height: 100,
                width: 70,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: a.images.length == 0
                      ? Image.asset('images/placeholder_book.png')
                      : Image.network(a.images[0]),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    a.bookTitle,
                    style: TextStyle(
                        color: Color(0xff96070a), fontWeight: FontWeight.bold),
                  ),
                  Text(a.authors,
                      style: TextStyle(color: Colors.black87, fontSize: 12)),
                  Text("Upplaga: " + a.edition, style: TextStyle())
                ],
              ),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            Expanded(
                flex: 2,
                child: Text(
                  a.price.toString() + ":-",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xff96070a)),
                )),
          ]),
        ),
      ),
    );
  }

  Container noAdverts(context) {
    Container returner = Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "Wooops! Verkar som du inte lagt upp några annonser än! (synd!)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: () {
              DataProvider.of(context).routing.routeCreationPage(context);
            },
            child: Text("Lägg till en annons"),
          ),
        ],
      ),
    );
    return returner;
  }

  Widget _profilePictureStyled() {
    String userImageURI = DataProvider.of(context).user.user.image;
    return GestureDetector(
      onTap: () {
        profilePicDialog();
      },
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
                text: DataProvider.of(context).user.user.username,
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
                text: DataProvider.of(context).user.user.soldBooks > 5
                    ? "Mellanliggande Bokförsäljare"
                    : "Novis Bokförsäljare",
                // Email tills vidare
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ]),
      ),
    );
  }

  void profilePicDialog() {
    print("Im in show alertDialog");
    Dialog dialog = Dialog(
      insetAnimationCurve: Curves.decelerate,
      insetAnimationDuration: Duration(milliseconds: 500),
      backgroundColor: Color(0xFFECE9DF),
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(DataProvider.of(context).user.user.image),
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
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
