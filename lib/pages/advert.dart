import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DataProvider.dart';

class Advert {
  final String bookTitle;
  final int owner = 1;
  final String isbn;
  int id;
  final int price;
  final String authors;
  String state = "A";
  String transactionType = "S";
  final String contactInfo;

  Advert(this.bookTitle, this.price, this.authors, this.isbn, this.contactInfo);

  Advert.fromJson(Map map)
      : bookTitle = map['book_title'],
        isbn = map['ISBN'],
        id = map["id"],
        price = map["price"],
        authors = map["authors"],
        state = map["state"],
        transactionType = map["transaction_type"],
        contactInfo = map["contact_info"];

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  Map<String, dynamic> toJson() => {
        'book_title': bookTitle,
        'price': price,
        'authors': authors,
        'ISBN': isbn,
        'state': state,
        'transaction_type': transactionType,
        'contact_info': contactInfo,
        'owner': owner
      };
}

class AdvertList {
  //StreamController<Advert> streamController;
  final List<Advert> list = [];

  Future<void> loadAdvertList() async {
    list.clear();
    String url = "https://fecbb9af.ngrok.io/adverts/adverts/?format=json";
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print("im in load method now");
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    for (int i = 0; i < resBody.length; i++) {
      list.add(Advert.fromJson(resBody[i]));
    }
    print("The Request body is: " + list.toString());
  }

//  Future<void> loadAdvertList() async {
//    streamController = StreamController.broadcast();
//    print("im in Advert List Load function");
//    streamController.stream.listen((a) => list.add(a));
//    String url = "https://fecbb9af.ngrok.io/adverts/adverts/?format=json";
//    var client = http.Client();
//    var req = http.Request('get', Uri.parse(url));
//    await load(streamController, client, req);
//
//  }

  List<Advert> getAdvertList() {
    return list;
  }

//
//  StreamController<Advert> getStreamController() {
//    return streamController;
//  }
//
//  void closeStreamController() {
//    streamController?.close();
//    streamController = null;
//  }

//  Future<void> load(
//      StreamController<Advert> sc, http.Client client, http.Request req) async {
//    var streamedRes = await client.send(req);
//    print("im in load method now");
//    print("the streamed response contains " +
//        streamedRes.contentLength.toString() +
//        " amounts of characters");
//    streamedRes.stream
//        .transform(utf8.decoder)
//        .transform(json.decoder)
//        .expand((e) => e)
//        .map((map) => Advert.fromJson(map))
//        .pipe(sc);
//  }

  Future<int> uploadNewAdvert(String title, int price, String author,
      String isbn, String contactInfo, context) async {
    Advert _newAd = Advert(title, price, author, isbn, contactInfo);
    var data = json.encode(_newAd);
    print(data);
    final String postURL = "https://fecbb9af.ngrok.io/adverts/adverts/";
    print("token " + DataProvider.of(context).user.getToken());
    final response =
        await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + DataProvider.of(context).user.getToken()
    });
    if (response.statusCode == 201) {
        await loadAdvertList();
    } else {
      throw Exception("Skapandet av en annons var inte lyckad");
    }
    return response.statusCode;
  }
}
