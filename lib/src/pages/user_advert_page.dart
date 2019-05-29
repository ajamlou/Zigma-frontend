import 'package:flutter/material.dart';
import 'package:zigma2/src/components/multiple_image_picker.dart';
import 'package:zigma2/src/data/advert.dart';
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
        appBar: AppBar(
          title: Text(
            "Redigera annons",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF373F51),
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFFAEDBD3),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Bilder",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF373F51)),
                  ),
                ),
                Container(
                  child: MultipleImagePicker(
                    images: widget.advert.images,
                    id: widget.advert.id
                  ),
                ),
                Text("Annonsinformation",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF373F51))),
                getCard(RegExp(""), widget.advert.bookTitle, "Titel",
                    widget.advert),
                getCard(RegExp(""), widget.advert.authors, "Författare",
                    widget.advert),
                getCard(RegExp(""), widget.advert.edition, "Upplaga",
                    widget.advert),
                getCard(RegExp(""), widget.advert.price.toString(), "Pris",
                    widget.advert),
                getCard(RegExp(""), widget.advert.isbn, "ISBN", widget.advert),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    width: 300,
                    child: RaisedButton(
                      color: Color(0xFF3FBE7E),
                      onPressed: () async {
                        await soldDialog(context);
                      },
                      child: Text("Markera annons som såld!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16)),
                    ),
                  ),
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
          "Är du säker på att du vill markera annonsen som såld? Detta kommer ta bort din annons.",
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
              color: Color(0xFF3FBE7E),
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
              child: Text("Ja",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 25,
            ),
            RaisedButton(
              color: Color(0xFFDE5D5D),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(null);
              },
              child: Text("Nej",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
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
