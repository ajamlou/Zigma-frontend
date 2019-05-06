import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';

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
          endDrawer: showDrawer(context),
          body: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _profilePictureStyled(),
              _profileNameStyled(),
              _profileRatingStyled(),
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
    return GestureDetector(
      onTap: showLargerPicture,
      child: Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Color(0xFF95453),
            radius: 75,
            backgroundImage: NetworkImage(
              DataProvider
                  .of(context)
                  .user
                  .getImage(),
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
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 30),
            children: [
              TextSpan(
                text: DataProvider
                    .of(context)
                    .user
                    .getUsername(),
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
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 20),
            children: [
              TextSpan(
                text: DataProvider
                    .of(context)
                    .user
                    .getEmail(),
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

  Widget showDrawer(context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(DataProvider
                .of(context)
                .user
                .user
                .username),
            decoration: BoxDecoration(
              color: const Color(0xff96070a),
            ),
            accountEmail: Text(DataProvider
                .of(context)
                .user
                .user
                .email),
            currentAccountPicture: DataProvider
                .of(context)
                .user
                .getImage() == null
                ? Container(
              width: 50,
              height: 50,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.account_circle, color: Color(0xFFece9df),),
              ),
            )
                : Stack(
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
                      image: DataProvider
                          .of(context)
                          .user
                          .getImage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Din Profil"),
            onTap: () async {
              DataProvider
                  .of(context)
                  .routing
                  .routeProfilePage(context);
            },
          ),
          ListTile(
            title: Text("Skapa Annons"),
            onTap: () async {
              DataProvider
                  .of(context)
                  .routing
                  .routeCreationPage(context);
            },
          ),
          ListTile(
              title: Text("Dina Chattar"),
              onTap: () async {
                DataProvider
                    .of(context)
                    .routing
                    .routeChatPage(context);
              }),
          ListTile(
            title: Text("Inställningar"),
            onTap: () {},
          ),
          ListTile(
              title: Text("Logga ut"),
              onTap: () {
                DataProvider
                    .of(context)
                    .user
                    .logout();
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop(null);
              }),
        ],
      ),
    );
  }

  Widget cardBuilder(String identifier) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonTheme
                .bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
