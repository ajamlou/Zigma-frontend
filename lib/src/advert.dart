import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DataProvider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'advert.g.dart';

@JsonSerializable()
class Advert {
  @JsonKey(name: 'book_title')
  String bookTitle;
  final int owner;
  @JsonKey(name: 'ISBN')
  String isbn;
  final String condition;
  String edition;
  int id;
  int price;
  String authors;
  String state = "A";
  @JsonKey(name: 'transaction_type')
  final String transactionType;
  @JsonKey(name: 'contact_info')
  final String contactInfo;
  @JsonKey(name: 'image')
  List<String> images;

  Advert(
      this.bookTitle,
      this.price,
      this.authors,
      this.isbn,
      this.contactInfo,
      this.condition,
      this.images,
      this.transactionType,
      this.edition,
      this.owner);

  factory Advert.fromJson(Map<String, dynamic> json) => _$AdvertFromJson(json);

  Map<String, dynamic> toJson(Advert advert) => _$AdvertToJson(advert);
}

class AdvertList {
  final String urlBody = "https://ecf116e6.eu.ngrok.io";
  final List<Advert> list = [];
  final List<Advert> userListSelling = [];
  final List<Advert> userListBuying = [];

  Future<void> loadAdvertList() async {
    list.clear();
    final String url = urlBody + "/adverts/adverts/recent_adverts/?format=json";
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    for (int i = 0; i < resBody.length; i++) {
      list.add(Advert.fromJson(resBody[i]));
    }
    print("The Request body is: " + list.toString());
  }

  String picUrl(int id){
    String url = urlBody+"/adverts/advertimages/"+id.toString()+"/";
    return url;
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
    String url = urlBody +
        "/adverts/adverts/?fields=book_title,price,authors,edition,image,owner,condition,ISBN&search=" +
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
    String url = urlBody +
        "/adverts/adverts/?transaction_type=" +
        transactionType +
        "&owner=" +
        owner.toString() +
        "&state=" +
        state;
    print(url);
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    final List<Advert> returnList = [];
    for (int i = 0; i < resBody.length; i++) {
      returnList.add(Advert.fromJson(resBody[i]));
    }
    return returnList;
  }

  Future<List<Advert>> getAdvertsFromIds(List<int> ids) async {
    print("IM IN GET ADVERTS FROM IDS");
    String url = urlBody + "/adverts/adverts/?ids=";
    for (int i = 0; i < ids.length; i++) {
      if (i == 0) {
        url = url + ids[i].toString();
      } else {
        url = url + "," + ids[i].toString();
      }
    }
    print(url);
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    List<Advert> returnList = [];
    for (int i = 0; i < resBody.length; i++) {
      returnList.add(Advert.fromJson(resBody[i]));
    }
    print(returnList);
    return returnList;
  }

  Future<Advert> getAdvertById(int id) async {
    final String url = urlBody + "/adverts/adverts/" + id.toString() + "/";
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
    var data = json.encode(_newAd.toJson(_newAd));
    print(data);
    final String postURL = urlBody + "/adverts/adverts/?format=json";
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
