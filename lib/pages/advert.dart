import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Advert {
  final String title;
  final String ISBN;

  Advert(
      this.title,
      this.ISBN
      );

  Advert.fromJsonMap(Map map)
      : title = map['book_title'],
        ISBN = map['ISBN'];
}

class AdvertList {
  StreamController<Advert> streamController;
  final List<Advert> list = [];

  void loadAdvertList() {
    streamController = StreamController();
    print("im in Advert List Load function");
    streamController.stream.listen((a) => list.add(a));
    load(streamController);
  }

  List<Advert> getAdvertList(){
    if(list.length == 0){
      return null;
    }
    return list;
  }

  void closeStreamController(){
    streamController?.close();
    streamController = null;
  }


  Future<void> load(StreamController sc) async {
    String url = "http://3ff52c0d.ngrok.io/api/adverts/?format=json";
    var client = http.Client();
    var req = http.Request('get',Uri.parse(url));
    var streamedRes = await client.send(req);
    print("im in load method now");
    streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Advert.fromJsonMap(map))
        .pipe(streamController);
  }

}