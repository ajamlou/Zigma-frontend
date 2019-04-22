import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Advert {
  final String bookTitle;
  final String isbn;
  int id;
  final String price;
  final String authors;
  String state;
  String transactionType;
  final String contactInfo;

  Advert(this.bookTitle, this.price, this.authors, this.isbn, this.contactInfo);

  Advert.fromJson(Map map)
      : bookTitle = map['book_title'],
        isbn = map['ISBN'],
        id = map["id"],
        price = map["price"].toString(),
        authors = map["authors"],
        state = map["state"],
        transactionType = map["transaction_type"],
        contactInfo = map["contact_info"];

  String toString() {
    String adToString = ("title: " +
        this.bookTitle +
        ",\nprice: " +
        this.price.toString() +
        ",\nauthors: " +
        this.authors +
        ",\nISBN: " +
        this.isbn +
        ",\ncontactInfo: " +
        this.contactInfo +
        ",\nstate: " +
        this.state +
        ",\ntransaction_type: " +
        this.transactionType);
    return adToString;
  }

  int stringToInt(price) {
    var priceInt = int.parse(price);
    assert(priceInt is int);
    return priceInt;
  }

  Map<String, dynamic> toJson() => {
        'book_title': bookTitle,
        'price': stringToInt(price),
        'authors': authors,
        'ISBN': isbn,
        'state': state,
        'transaction_type': transactionType,
        'contact_info': contactInfo
      };



}

class AdvertList {
  StreamController<Advert> streamController;
  final List<Advert> list = [];

  Future<void> loadAdvertList() async {
    streamController = StreamController.broadcast();
    print("im in Advert List Load function");
    streamController.stream.listen((a) => list.add(a));
    String url = "https://fecbb9af.ngrok.io/adverts/adverts/?format=json";
    var client = http.Client();
    var req = http.Request('get', Uri.parse(url));
    await load(streamController, client, req);
  }

  List<Advert> getAdvertList() {
    return list;
  }

  StreamController<Advert> getStreamController() {
    return streamController;
  }

  void closeStreamController() {
    streamController?.close();
    streamController = null;
  }

  Future<void> load(
      StreamController<Advert> sc, http.Client client, http.Request req) async {
    var streamedRes = await client.send(req);
    print("im in load method now");
    print("the streamed response contains "+streamedRes.contentLength.toString()+" amounts of characters" );
    streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Advert.fromJson(map))
        .pipe(sc);
  }
  Future<String> uploadNewAdvert(String title, String price, String author, String isbn, String contactInfo) async {
    final Advert _newAd = new Advert(title, price, author, isbn, contactInfo);
    var data = json.encode(_newAd);
    final String postURL = "https://fecbb9af.ngrok.io/adverts/adverts/?format=json";
    var response =
    await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      //"Authorization": "Token "+ DataProvider.of(context).user.getToken()
    });
    return json.decode(response.body);
  }



}


