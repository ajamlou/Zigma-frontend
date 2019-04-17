import 'package:flutter/material.dart';
import './login_page.dart';
import './search_page.dart';
import './searchbar.dart';
import './advert_creation.dart';
import './chat_page.dart';

class LandingPage extends StatelessWidget {
  final Function refreshPage;

  LandingPage({this.refreshPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/backgroundImage.jpg"),
            fit: BoxFit.fitHeight,
        ),
      ),
      //color: Color(0xFFFFFFFF),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff96070a)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            LoginButton()
          ],
        ),
        drawer: showDrawer(context),
        body: Container(
         // color: Color(0xFFFFFFFF),
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(
                      top: 100.0, left: 50, right: 50, bottom: 100),
                  child: Image.asset('images/logo_frontpage.png')),
              Container(
                height: 50,
                decoration: new BoxDecoration(
                  color: Color(0xFFECE9DF),
                  borderRadius: new BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: MaterialButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchPage(),
                    );
                    refreshPage();
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Icon(Icons.search),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text('Sök efter din litteratur...'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget showDrawer(context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("RandomName"),
          decoration: BoxDecoration(
              color: const Color(0xff96070a),
          ),
          accountEmail: Text("random@random.com"),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://pbs.twimg.com/profile_images/723864085826277376/P0w7UfP8.jpg'),
          ),
        ),
        ListTile(
          title: Text("Din Profil"),
          onTap: () {

          },
        ),
        ListTile(
          title: Text("Skapa Annons"),
          onTap:() async {
            routeCreationPage(context);
          },
        ),
        ListTile(
            title: Text("Dina Chattar"),
            onTap: () {
              Navigator.of(context)
                  .push(
                  MaterialPageRoute<void>(builder: (_) => FriendlyChatApp()));
            }
        ),
        ListTile(
          title: Text("Inställningar"),
          onTap: () {},
        ),
      ],
    ),
  );
}


void routeCreationPage(context) {
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => advertCreation()));
}


void routeSearchPage(context) {
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => Searchbar()));
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MaterialButton(
        onPressed: () async => routeLoginPage(context),
        child: Column(
          children: <Widget>[
            Icon(Icons.contacts),
            Text('Logga In'),
          ],
        ),
      ),
    );
  }

  void routeLoginPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => LoginPage()));
  }
}
