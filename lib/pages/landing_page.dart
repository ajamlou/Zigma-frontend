import 'package:flutter/material.dart';
import './login_page.dart';
import './search_page.dart';
import './advert_creation.dart';
import './chat_page.dart';
import 'DataProvider.dart';
import 'RegisterPage.dart';

class LandingPage extends StatelessWidget {
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
            DataProvider.of(context).user.checkUser()
                ? Container(
                    padding: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://pbs.twimg.com/profile_images/723864085826277376/P0w7UfP8.jpg"),
                      ),
                    ),
                  )
                : LoginButton()
          ],
        ),
        drawer: DataProvider.of(context).user.checkUser()
            ? showDrawer(context)
            : Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECE9DF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    height: 125,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Du behöver ett konto för att fortsätta.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Color(0xff96070a)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RaisedButton(
                          color: Colors.lightBlueAccent,
                          child: Text("Skapa ett Zigma konto", style: TextStyle(color: Colors.white)),
                          onPressed: () async => routeRegisterPage(context),
                        ),
                      ],
                    ),
                ),
              ),
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
                decoration: BoxDecoration(
                  color: Color(0xFFECE9DF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: MaterialButton(
                  onPressed: () {
                    //DataProvider.of(context).advertList.loadAdvertList();
                    showSearch(
                      context: context,
                      delegate: SearchPage(),
                    );
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
          onTap: () {},
        ),
        ListTile(
          title: Text("Skapa Annons"),
          onTap: () async {
            routeCreationPage(context);
          },
        ),
        ListTile(
            title: Text("Dina Chattar"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => FriendlyChatApp()));
            }),
        ListTile(
          title: Text("Inställningar"),
          onTap: () {},
        ),
      ],
    ),
  );
}
void routeRegisterPage(context) {
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => RegisterPage()));
}

void routeLoginPage(context) {
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => LoginPage()));
}

void routeCreationPage(context) {
  Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => AdvertCreation()));
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


}
