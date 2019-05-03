import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:zigma2/src/advert.dart';
import 'package:zigma2/src/components/carousel.dart';

class AdvertPage extends StatefulWidget {
  final Advert data;

  AdvertPage({this.data});

  @override
  _AdvertPageState createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/advertPageBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: AppBar(
            iconTheme: IconThemeData(color: Color(0xffECE9DF)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              alignment: Alignment(0, 0),
              height: 50,
              child: Text(
                widget.data.bookTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFECE9DF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            widget.data.images.length == 0
                ? Image.asset('images/calc_book.png')
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 75),
                    height: 300,
                    child: Carousel(images: widget.data.images),
                  ),
            SizedBox(
              height: 30,
            ),
            getText("Författare: ", widget.data.authors),
            getText("Upplaga: ", "SÄTT UPPLAGA HÄR"),
            getText("Skick: ", widget.data.condition),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.data.price.toString() + ":-",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xff96070a),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                DataProvider.of(context).user.getImage() == null
                    ? Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 2,
                        child: Stack(
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
                                  image:
                                      DataProvider.of(context).user.getImage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  flex: 8,
                  child: Text(
                    widget.data.contactInfo +
                        " har sålt 14 böcker och köpt 3 böcker.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.chat_bubble),
                        Text("Skicka ett meddelande till " +
                            widget.data.contactInfo)
                      ],
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

  RichText getText(leading, content) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: leading,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xff96070a),
        ),
        children: [
          TextSpan(
            text: content,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
