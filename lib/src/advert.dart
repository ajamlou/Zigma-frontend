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
  final String transaction_type;
  final String contactInfo;
  List<dynamic> images;

  Advert(
      this.bookTitle,
      this.price,
      this.authors,
      this.isbn,
      this.contactInfo,
      this.condition,
      this.images,
      this.transaction_type,
      this.edition,
      this.owner);

  Advert.fromJson(Map map)
      : bookTitle = map['book_title'],
        price = map["price"],
        authors = map["authors"],
        isbn = map['ISBN'],
        contactInfo = map["contact_info"],
        condition = map["condition"],
        images = map["image"],
        transaction_type = map["transaction_type"],
        edition = map["edition"],
        owner = map["owner"],
        id = map["id"],
        state = map["state"];

  Map<String, dynamic> toJson() => {
        'book_title': bookTitle,
        'price': price,
        'authors': authors,
        'ISBN': isbn,
        'contact_info': contactInfo,
        'condition': condition,
        'image': images,
        'transaction_type': transaction_type,
        'edition': edition,
        'owner': owner,
        'state': state
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

  void clearUserAdvertList() {
    userList.clear();
  }

  Future<List<Advert>> getAdvertsFromIds(context) async {
    List<int> ids = DataProvider.of(context).user.getAdvertIds();
    print("IM IN GET ADVERTS FROM IDS");
    String url = "https://9548fc36.ngrok.io/adverts/adverts/?ids=";
    for (int i = 0; i < ids.length; i++) {
      if (i == 0) {
        url = url + ids[i].toString();
      } else {
        url = url + "," + ids[i].toString();
      }
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

  List<Advert> getUserAdvertList() {
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

  String convertCondition(String condition) {
    String number;
    if (condition == '1') {
      number = 'Nyskick';
    } else if (condition == '2') {
      number = 'Mycket gott skick';
    } else if (condition == '3') {
      number = 'Gott skick';
    } else if (condition == '4') {
      number = 'Hyggligt skick';
    } else if (condition == '5') {
      number = 'Dåligt skick';
    } else {
      number = 'Skick ej angivet';
    }
    return number;
  }

  String checkCondition(String condition) {
    String number;
    if (condition == 'Nyskick') {
      number = '1';
    } else if (condition == 'Mycket gott skick') {
      number = '2';
    } else if (condition == 'Gott skick') {
      number = '3';
    } else if (condition == 'Hyggligt skick') {
      number = '4';
    } else if (condition == 'Dåligt skick') {
      number = '5';
    } else {
      number = '6';
    }
    return number;
  }

  Future<List> uploadNewAdvert(
      String title,
      int price,
      String author,
      String isbn,
      String contactInfo,
      List<String> encodedImageList,
      String condition,
      String transactionType,
      String edition,
      context) async {
    condition = checkCondition(condition);
    List<int> l = [];
    Advert _newAd = Advert(title, price, author, isbn, contactInfo, condition,
        encodedImageList, transactionType, edition, 1);
    var data = json.encode(_newAd);
    final String postURL =
        "https://9548fc36.ngrok.io/adverts/adverts/?format=json";
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
