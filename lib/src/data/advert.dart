import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:zigma2/src/DataProvider.dart';
import 'package:flutter/material.dart';

part 'package:zigma2/src/data/advert.g.dart';

class Advert {
  String bookTitle;
  final int owner;
  String isbn;
  final String condition;
  String edition;
  int id;
  int price;
  String authors;
  String state = "A";
  final String transactionType;
  final String contactInfo;
  List<Map<String, dynamic>> images;
  List<String> encodedImageList;

  Advert(
      {this.bookTitle,
      this.price,
      this.authors,
      this.isbn,
      this.contactInfo,
      this.condition,
      this.images,
      this.transactionType,
      this.edition,
      this.owner,
      this.encodedImageList});

  String toString() {
    return "BookTitle: " +
        bookTitle +
        " Price: " +
        price.toString() +
        " Authors: " +
        authors +
        " isbn: " +
        isbn +
        " Contact info: " +
        contactInfo +
        " Condition: " +
        condition +
        " Transaction Type: " +
        transactionType +
        " Edition: " +
        edition +
        " Owner: " +
        owner.toString() +
        " Encoded Image List: " +
        encodedImageList.toString();
  }

  factory Advert.fromJson(Map<String, dynamic> json) => _$AdvertFromJson(json);

  Map<String, dynamic> toJson(Advert advert) => _$AdvertToJson(advert);
}

class AdvertList {
  final String urlBody = "https://1b55720e.eu.ngrok.io";
  final List<Advert> list = [];


  Future<void> loadAdvertList() async {
    print("request sent");
    final String url = urlBody + "/adverts/adverts/recent_adverts/?format=json";
    final stopwatch = Stopwatch()..start();
    final request = await http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "Connection": "close",
      "Content-Type": "applicaion/json"
    });
    print('doSomething() executed in ${stopwatch.elapsed}');
    stopwatch.stop();
    final List resBody = json.decode(utf8.decode(request.bodyBytes));
    print("request recieved");
    for (int i = 0; i < resBody.length; i++) {
      list.add(Advert.fromJson(resBody[i]));
    }
  }

  Future<Map> editAdvert(String header, dynamic edit, int id, context) async {
    String url = urlBody + "/adverts/adverts/" + id.toString() + "/";
    Map changes = {header: edit};
    print(changes.toString());
    var data = json.encode(changes);
    var response = await http.patch(Uri.encodeFull(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + DataProvider.of(context).user.user.token
    });
    if (response.statusCode == 200) {
      return changes;
    } else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  String picUrl(int id) {
    final String url = urlBody + "/adverts/advertimages/" + id.toString() + "/";
    return url;
  }

  Future<List<Advert>> searchAdverts(String query) async {
    List<Advert> returnList = [];
    String url = urlBody +
        "/adverts/adverts/?fields=book_title,price,authors,edition,image,owner,condition,ISBN,id&search=" +
        query;
    print(url);
    final req = await http
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
    final req = await http
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
    final req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    final List resBody = json.decode(utf8.decode(req.bodyBytes));
    final List<Advert> returnList = [];
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
    Advert _newAd = Advert(
        bookTitle: title,
        price: price,
        authors: author,
        isbn: isbn,
        contactInfo: contactInfo,
        condition: condition,
        encodedImageList: encodedImageList,
        transactionType: transactionType,
        edition: edition,
        owner: DataProvider.of(context).user.user.id);
    var data = json.encode(_newAd.toJson(_newAd));
    print(data);
    final String postURL = urlBody + "/adverts/adverts/?format=json";
    final response =
        await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + DataProvider.of(context).user.user.token
    });
    Map decoded = jsonDecode(utf8.decode(response.bodyBytes));
    print(decoded.toString());
    if (response.statusCode == 201) {
      Advert a = await DataProvider.of(context)
          .advertList
          .getAdvertById(decoded["id"]);
      _newAd.images = a.images;
      list.insert(0, _newAd);
    }
    return [response.statusCode, _newAd];
  }
}
