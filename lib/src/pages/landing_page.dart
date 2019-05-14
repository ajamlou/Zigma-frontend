import 'package:flutter/material.dart';
import 'package:zigma2/src/components/login_prompt.dart';
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
              DataProvider.of(context).user.user != null
                  ? SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : LoginButton()
            ],
          ),
          drawer: DataProvider.of(context).user.user != null
              ? showDrawer(context)
              : Center(
                  child: Container(
                    color: Colors.transparent,
                    width: 300,
                    height: 190,
                    child: LoginPrompt(),
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
                  child: Hero(
                    tag: 'search page',
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
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Sök efter din litteratur...', style: TextStyle( fontSize:  18)),
                            ),
                          ],
                        ),
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
            accountEmail: DataProvider.of(context).user.user.soldBooks > 5
                ? Text("Intermediate Book Seller")
                : Text("Novice Book Seller"),
            currentAccountPicture:
                DataProvider.of(context).user.user.image == null
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
                                image: DataProvider.of(context).user.user.image,
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
                DataProvider.of(context).loadingScreen.showLoadingDialog(context);
                Future.delayed(Duration(milliseconds: 1500), () async {
                  await DataProvider.of(context).user.logout(context);
                  setState(() {});
                  Navigator.of(context, rootNavigator: true).pop(null);
                  Navigator.of(context, rootNavigator: true).pop(null);
                });
              }),
        ],
      ),
    );
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
