import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DataProvider.dart';

class Advert {
  final String bookTitle;
  final int owner;
  final String isbn;
  final String condition;
  final String edition;
  int id;
  final int price;
  final String authors;
  String state = "A";
  String transactionType = "S";
  final String contactInfo;
  List<dynamic> images;

  Advert(this.bookTitle, this.price, this.authors, this.isbn, this.contactInfo,
      this.images, this.condition, this.edition, this.owner);

  Advert.fromJson(Map map)
      : bookTitle = map['book_title'],
        isbn = map['ISBN'],
        id = map["id"],
        price = map["price"],
        authors = map["authors"],
        state = map["state"],
        transactionType = map["transaction_type"],
        contactInfo = map["contact_info"],
        images = map["image"],
        condition = map["condition"],
        edition = map["edition"],
        owner = map["owner"];

  Map<String, dynamic> toJson() => {
        'book_title': bookTitle,
        'price': price,
        'authors': authors,
        'ISBN': isbn,
        'state': state,
        'transaction_type': transactionType,
        'contact_info': contactInfo,
        'owner': owner,
        'image': images,
        'condition': condition,
        'edition': edition
      };
}

class AdvertList {
  final List<Advert> list = [];
  final List<Advert> userList = [];

  Future<void> loadAdvertList() async {
    list.clear();
    final String url =
        "https://9548fc36.ngrok.io/adverts/adverts/recent_adverts/?format=json";
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print("im in load method now");
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    for (int i = 0; i < resBody.length; i++) {
      list.add(Advert.fromJson(resBody[i]));
    }
    print("The Request body is: " + list.toString());
  }

  Future<List<Advert>> getAdvertsFromIds(context) async {
    List<int> ids = DataProvider.of(context).user.getAdvertIds();
    print("IM IN GET ADVERTS FROM IDS");
    String url = "https://9548fc36.ngrok.io/adverts/adverts/?ids=";
    for (int i = 0; i > ids.length; i++) {
      url = url + "," + ids[i].toString();
    }
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    for (int i = 0; i < resBody.length; i++) {
      userList.add(Advert.fromJson(resBody[i]));
    }
    return userList;
  }

  List<Advert> getAdvertList() {
    return list;
  }

  List<Advert> getUserAdvertList(){
    return userList;
  }

  Future<Advert> getAdvertById(int id) async {
    final String url =
        "https://9548fc36.ngrok.io/adverts/adverts/" + id.toString() + "/";
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final resBody = json.decode(utf8.decode(req.bodyBytes));
    return Advert.fromJson(resBody);
  }

  Future<List> uploadNewAdvert(
      String title,
      int price,
      String author,
      String isbn,
      String contactInfo,
      List<String> encodedImageList,
      context) async {
    List<int> l = [];
    Advert _newAd = Advert(title, price, author, isbn, contactInfo,
        encodedImageList, "1", "Kinda fucked", 8);
    var data = json.encode(_newAd);
    print(data);
    final String postURL =
        "https://9548fc36.ngrok.io/adverts/adverts/?format=json";
    print("token " + DataProvider.of(context).user.getToken());
    final response =
        await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + DataProvider.of(context).user.getToken()
    });
    Map decoded = json.decode(response.body);
    l.add(response.statusCode);
    l.add(decoded["id"]);
    if (response.statusCode == 201) {
      await loadAdvertList();
    }
    return l;
  }
}
