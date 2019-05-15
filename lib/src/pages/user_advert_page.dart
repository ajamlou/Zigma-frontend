import 'package:flutter/material.dart';
import 'package:zigma2/src/advert.dart';

class UserAdvertPage extends StatefulWidget {
  final Advert advert;

  UserAdvertPage({this.advert});

  @override
  _UserAdvertPageState createState() => _UserAdvertPageState();
}

class _UserAdvertPageState extends State<UserAdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
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
            advertAttribute("Title: " + widget.advert.bookTitle),
            advertAttribute("Författare: " + widget.advert.authors),
            advertAttribute("Upplaga: " + widget.advert.edition),
            advertAttribute("Pris: " + widget.advert.price.toString()),
            RaisedButton(
              onPressed: (){},
              child: Text("Markera annons som såld!"),
            ),
            Image.network("https://9548fc36.ngrok.io/adverts/advertimages/2"),
          ],
        ),
      ),
    );
  }

  Widget advertAttribute(String text) {
    return Row(
      children: <Widget>[
        Text(text),
        MaterialButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        ),
      ],
    );
  }
}
