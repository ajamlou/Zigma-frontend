import 'package:flutter/material.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/components/edit.dart';

import '../DataProvider.dart';

class UserAdvertPage extends StatefulWidget {
  final Advert advert;
  final List sellingAdverts;
  final List buyingAdverts;

  UserAdvertPage({this.advert, this.sellingAdverts, this.buyingAdverts});

  @override
  _UserAdvertPageState createState() => _UserAdvertPageState();
}

class _UserAdvertPageState extends State<UserAdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Bilder",
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.advert.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(border: Border.all(width: 2)),
                        child: GestureDetector(
                          onTap: () {},
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.network(
                                widget.advert.images[index],
                              ),
                              Positioned(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  "Annonsinformation",
                  style: TextStyle(fontSize: 30),
                ),
                getCard(RegExp(""), widget.advert.bookTitle, "Titel",
                    widget.advert),
                getCard(RegExp(""), widget.advert.authors, "Författare",
                    widget.advert),
                getCard(RegExp(""), widget.advert.edition, "Upplaga",
                    widget.advert),
                getCard(RegExp(""), widget.advert.price.toString(), "Pris",
                    widget.advert),
                getCard(RegExp(""), widget.advert.isbn, "ISBN", widget.advert),
                RaisedButton(
                  onPressed: () async {
                    await soldDialog(context);
                  },
                  child: Text("Markera annons som såld!"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> soldDialog(context) async {
    AlertDialog dialog = AlertDialog(
        title: Text(
          "Är du säker på att du vill markera annonsen som såld? Detta kommer ta bort din annons",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF373F51),
          ),
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                DataProvider.of(context)
                    .user
                    .editAdvert("state", "I", widget.advert.id);
                widget.sellingAdverts
                    .removeWhere((a) => a.id == widget.advert.id);
                widget.buyingAdverts
                    .removeWhere((a) => a.id == widget.advert.id);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Ja"),
            ),
            SizedBox(
              width: 25,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(null);
              },
              child: Text("Nej"),
            ),
          ],
        ));
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Widget getCard(RegExp regExp, String edit, String title, Advert a) {
    return Card(
      color: Colors.grey[100],
      child: ListTile(
        onTap: () async {
          String newString = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Edit(regExp: regExp, title: title, edit: edit),
            ),
          );
          if (newString != edit) {
            if (title == "Titel") {
              DataProvider.of(context)
                  .user
                  .editAdvert("book_title", newString, a.id);
              a.bookTitle = newString;
            } else if (title == "Författare") {
              DataProvider.of(context)
                  .user
                  .editAdvert("authors", newString, a.id);
              a.authors = newString;
            } else if (title == "Upplaga") {
              DataProvider.of(context)
                  .user
                  .editAdvert("edition", newString, a.id);
              a.edition = newString;
            } else if (title == "Pris") {
              var newInt = int.parse(newString);
              assert(newInt is int);
              DataProvider.of(context).user.editAdvert("price", newInt, a.id);
              a.price = newInt;
            } else if (title == "ISBN") {
              DataProvider.of(context).user.editAdvert(title, newString, a.id);
              a.isbn = newString;
            }
          }
          setState(() {});
        },
        leading: Text(title),
        trailing: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(edit),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
