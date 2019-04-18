import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Advert {
  final String book_title;
  final String ISBN;
  final int id;
  final int price;
  final String authors;
  final String state;
  final String transaction_type;
  final String contact_info;

  Advert.fromJson(Map map)
      : book_title = map['book_title'],
        ISBN = map['ISBN'],
        id = map["id"],
        price = map["price"],
        authors = map["authors"],
        state = map["state"],
        transaction_type = map["transaction_type"],
        contact_info = map["contact_info"];
}

class AdvertList {
  StreamController<Advert> streamController;
  final List<Advert> list = [];

  void loadAdvertList() {
    streamController = StreamController.broadcast();
    print("im in Advert List Load function");
    streamController.stream.listen((a) => list.add(a));
    String url = "https://3ff52c0d.ngrok.io/api/adverts/?format=json";
    var client = http.Client();
    var req = http.Request('get', Uri.parse(url));
    load(streamController, client, req);
  }

  List<Advert> getAdvertList() {
    print(list);
    return list;
  }

  StreamController<Advert> getStreamController() {
    return streamController;
  }

  void closeStreamController() {
    streamController?.close();
    streamController = null;
  }

  Future<void> load(StreamController<Advert> sc, http.Client client, http.Request req) async {
    var streamedRes = await client.send(req);
    print("im in load method now");
    streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Advert.fromJson(map))
        .pipe(sc);
  }
}
