import 'package:flutter/material.dart';
import 'package:zigma2/src/pages/search_page.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:transparent_image/transparent_image.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
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
                  ? SizedBox(
                      width: 0,
                      height: 0,
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
                    height: 190,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Du behöver ett konto för att fortsätta.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff96070a)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        RaisedButton(
                          color: Colors.greenAccent,
                          child: Text("Logga in",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async => DataProvider.of(context)
                              .routing
                              .routeLoginPage(context),
                        ),
                        Text("eller"),
                        RaisedButton(
                          color: Colors.lightBlueAccent,
                          child: Text("Skapa ett Zigma konto",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async => DataProvider.of(context)
                              .routing
                              .routeRegisterPage(context),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
      ),
    );
  }

  Widget showDrawer(context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(DataProvider.of(context).user.user.username),
            decoration: BoxDecoration(
              color: const Color(0xff96070a),
            ),
            accountEmail: Text(DataProvider.of(context).user.user.email),
            currentAccountPicture:
                DataProvider.of(context).user.getImage() == null
                    ? Container(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.account_circle,
                            color: Color(0xFFece9df),
                          ),
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
                                image: DataProvider.of(context).user.getImage(),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
          ListTile(
            title: Text("Din Profil"),
            onTap: () async {
              DataProvider.of(context).routing.routeProfilePage(context);
            },
          ),
          ListTile(
            title: Text("Skapa Annons"),
            onTap: () async {
              DataProvider.of(context).routing.routeCreationPage(context);
            },
          ),
          ListTile(
              title: Text("Dina Chattar"),
              onTap: () async {
                Navigator.of(context, rootNavigator: true).pop(null);
                DataProvider.of(context).routing.routeChatPage(context, false);
              }),
          ListTile(
            title: Text("Inställningar"),
            onTap: () {},
          ),
          ListTile(
              title: Text("Logga ut"),
              onTap: () async {
                showLoadingAlertDialog();
                await DataProvider.of(context).user.logout();
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop(null);
                Navigator.of(context, rootNavigator: true).pop(null);
              }),
        ],
      ),
    );
  }
  void showLoadingAlertDialog() {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Color(0xFFECE9DF),
      title: Text(
        "Laddar...",
        style: TextStyle(
          fontSize: 20,
          color: Color(0xff96070a),
        ),
        textAlign: TextAlign.center,
      ),
      content: DataProvider.of(context).loadingScreen,
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vill du verkligen stänga appen?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Nej"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Ja"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ));
  }

}



class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MaterialButton(
        onPressed: () async =>
            DataProvider.of(context).routing.routeLoginPage(context),
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
