import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Advert {
  final String title;
  final String ISBN;

  Advert.fromJsonMap(Map map)
      : title = map['title'],
        ISBN = map['ISBN'];
}

class AdvertList extends StatefulWidget {
  @override
  AdvertListState createState() => AdvertListState();
}

class AdvertListState extends State<AdvertList> {
  StreamController<Advert> streamController;
  List<Advert> list = [];

  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();
    streamController.stream.listen((a) => setState(() => list.add(a)));
    load(streamController);
  }

  load(StreamController sc) async {
    String url = "http://b8759835.ngrok.io1/api/books/?format=json";
    var client = new http.Client();
    var req = new http.Request('get', Uri.parse(url));
    var streamedRes = await client.send(req);
    streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Advert.fromJsonMap(map))
        .pipe(streamController);
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _makeElement(index),
      ),
    );
  }

  Widget _makeElement(int index) {
    //_makeElement({this.query});
    if (index >= list.length) {
      return null;
    }
    return Container(
      child: MaterialButton(
        padding: EdgeInsets.all(10.0),
        onPressed: () {},
        child: Column(
          children: <Widget>[
            Text(list[index].title),
            Text(list[index].ISBN),
          ],
        ),
      ),
    );
  }
}
