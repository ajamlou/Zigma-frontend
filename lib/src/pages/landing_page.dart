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
            iconTheme: IconThemeData(color: Color(0xffDE5D5D)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              DataProvider.of(context).user.user != null
                  ? SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : loginButton()
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
                    color: Colors.white,
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
                              child: Text('Sök efter din litteratur...',
                                  style: TextStyle(fontSize: 18)),
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
      child: Container(
        color: Color(0xFFAEDBD3),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: DataProvider.of(context).user.user.image == null
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
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  child: FadeInImage.memoryNetwork(
                                    fit: BoxFit.fitWidth,
                                    placeholder: kTransparentImage,
                                    image: DataProvider.of(context)
                                        .user
                                        .user
                                        .image,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DataProvider.of(context).user.user.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),
                        ),
                        DataProvider.of(context).user.user.soldBooks > 5
                            ? Text(
                                "Ganska Bra Boksäljare",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : Text(
                                "Novis Boksäljare",
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Din Profil",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              ),
              onTap: () async {
                DataProvider.of(context).routing.routeProfilePage(context);
              },
            ),
            ListTile(
              title: Text(
                "Skapa Annons",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),
              ),
              onTap: () async {
                DataProvider.of(context).routing.routeCreationPage(context);
              },
            ),
            ListTile(
                title: Text(
                  "Dina Chattar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),
                ),
                onTap: () async {
                  Navigator.of(context, rootNavigator: true).pop(null);
                  DataProvider.of(context)
                      .routing
                      .routeChatPage(context, false);
                }),
            ListTile(
              title: Text(
                "Inställningar",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 20),
              ),
              onTap: () {},
            ),
            Expanded(
              flex: 8,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xFFDE5D5D)),
                  child: FlatButton(
                      child: Text(
                        "Logga ut",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () async {
                        DataProvider.of(context)
                            .loadingScreen
                            .showLoadingDialog(context);
                        Future.delayed(Duration(milliseconds: 1500), () async {
                          await DataProvider.of(context).user.logout(context);
                          setState(() {});
                          Navigator.of(context, rootNavigator: true).pop(null);
                          Navigator.of(context, rootNavigator: true).pop(null);
                        });
                      }),
                ),
              ),
            ),
          ],
        ),
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
  Widget loginButton(){
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

