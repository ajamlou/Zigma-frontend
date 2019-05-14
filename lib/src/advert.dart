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
        'ISBN': isbn == "" ? "Ej angett" : isbn,
        'contact_info': contactInfo,
        'condition': condition,
        'image': images,
        'transaction_type': transaction_type,
        'edition': edition == "" ? "Ej angett" : edition,
        'owner': owner,
        'state': state
      };
}

class AdvertList {
  final List<Advert> list = [];
  final List<Advert> userListSelling = [];
  final List<Advert> userListBuying = [];

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
    userListSelling.clear();
    userListBuying.clear();
  }

  Future<List> getCombinedUserLists() async {
    List newList = [userListBuying, userListSelling].expand((x) => x).toList();
    return newList;
  }

  Future<List<Advert>> searchAdverts(String query) async {
    List<Advert> returnList = [];
    String url =
        "https://9548fc36.ngrok.io/adverts/adverts/?fields=book_title,price,authors,edition,image,owner&search=" +
            query;
    print(url);
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final resBody = json.decode(utf8.decode(req.bodyBytes));
    print(resBody.toString());
    for (int i = 0; i < resBody.length; i++) {
      returnList.add(Advert.fromJson(resBody[i]));
    }
    return returnList;
  }

  Future<List<Advert>> getSpecificAdverts(
      String transactionType, int owner, String state) async {
    String url =
        "https://9548fc36.ngrok.io/adverts/adverts/?transaction_type=" +
            transactionType +
            "&owner=" +
            owner.toString() +
            "&state=" +
            state;
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    for (int i = 0; i < resBody.length; i++) {
      if (transactionType == "B") {
        userListBuying.add(Advert.fromJson(resBody[i]));
      } else {
        userListSelling.add(Advert.fromJson(resBody[i]));
      }
    }
    if (transactionType == "B") {
      return userListBuying;
    }
    return userListSelling;
  }

  Future<List<Advert>> getAdvertsFromIds(List<int> ids) async {
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
    List returnList = [];
    for (int i = 0; i < resBody.length; i++) {
      returnList.add(Advert.fromJson(resBody[i]));
    }
    return returnList;
  }

  Future<Advert> getAdvertById(int id) async {
    final String url =
        "https://9548fc36.ngrok.io/adverts/adverts/" + id.toString() + "/";
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final resBody = json.decode(utf8.decode(req.bodyBytes));
    return Advert.fromJson(resBody);
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
    Advert _newAd = Advert(title, price, author, isbn, contactInfo, condition,
        encodedImageList, transactionType, edition, 1);
    var data = json.encode(_newAd);
    print(data);
    final String postURL =
        "https://9548fc36.ngrok.io/adverts/adverts/?format=json";
    final response =
        await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + DataProvider.of(context).user.user.token
    });
    Map decoded = json.decode(response.body);
    if (response.statusCode == 201) {
      await loadAdvertList();
      Advert a = await getAdvertById(decoded["id"]);
      userListSelling.add(a);
    }
    return [response.statusCode, decoded["id"]];
  }
}
