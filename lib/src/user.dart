import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String email;
  int id;
  String username;
  String token;
  @JsonKey(name: 'img_link')
  int profile;
  bool hasPicture;
  List<int> adverts;
  @JsonKey(name: 'sold_books')
  int soldBooks;
  @JsonKey(name: 'bought_books')
  int boughtBooks;

  User(this.email, this.id, this.username, this.token, this.profile,
      this.hasPicture, this.adverts, this.soldBooks, this.boughtBooks);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson(User json) => _$UserToJson(json);
}

class UserCreation {
  String email;
  String username;
  String password;
  String imageAsBytes;

  UserCreation(this.email, this.username, this.password, this.imageAsBytes);

  // om imageAsBytes är null, encode utan den parametern
  Map<String, dynamic> toJson() =>
      imageAsBytes != null
          ? {
        'username': username,
        'password': password,
        'email': email,
        'profile_picture': imageAsBytes,
      }
          : {
        'username': username,
        'password': password,
        'email': email,
      };

  UserCreation.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        password = json['password'];
}

class UserLogin {
  String username;
  String password;

  UserLogin(this.username, this.password);

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'password': password,
      };
}

class UserMethodBody {
  User user;
  String urlBody = "https://ecf116e6.eu.ngrok.io";

  UserMethodBody(this.user);

  void iniUser(String email, int id, String username, String token, int profile,
      bool hasPicture,
      List<int> adverts) {
    user = User(
        email,
        id,
        username,
        token,
        profile,
        hasPicture,
        adverts,
        0,
        0);
  }

  Future<User> getUserById(int id, String fields) async {
    final String url =
        urlBody + "/users/users/" + id.toString() + "/?fields=" + fields;
    print("IM IN getUserById wihooo");
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print("Im finished with the http request");
    var resBody = json.decode(utf8.decode(req.bodyBytes));
    print(resBody.toString());
    var user = User.fromJson(resBody);
    print(user.username);
    return user;
  }

  String picUrl(int id) {
    print("IM IN PICURL");
    String url = urlBody + "/users/profile_pic/" + id.toString()+"/";
    print(url);
    return url;
  }

  Future<void> logout(context) async {
    user = null;
    DataProvider
        .of(context)
        .advertList
        .clearUserAdvertList();
    await clearPrefs();
  }

  Future<void> setUserPreferences(String token, int profile, bool hasPicture,
      String username,
      String email, int id, List adverts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setInt("profile", profile);
    prefs.setBool("hasPicture", hasPicture);
    prefs.setString("username", username);
    prefs.setString("email", email);
    prefs.setInt("id", id);
    prefs.setStringList("adverts", adverts.map((i) => i.toString()).toList());
  }

  Future<void> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> automaticLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("token") == null) {} else {
      iniUser(
          prefs.getString("email"),
          prefs.getInt("id"),
          prefs.getString("username"),
          prefs.getString("token"),
          prefs.getInt("profile"),
          prefs.getBool("hasPicture"),
          prefs.getStringList("adverts").map((i) => int.parse(i)).toList());
    }
  }

  Future<List> register(String email, String username, String password,
      String imageAsBytes) async {
    List<dynamic> returnList = [];
    UserCreation _newUser =
    UserCreation(email, username, password, imageAsBytes);
    var data = json.encode(_newUser);
    print(data);
    String postURL = urlBody + "/users/users/";
    var response = await http.post(Uri.encodeFull(postURL),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    final String res = response.body;
    print(json.decode(res));
    Map parsed = json.decode(res);
    print(parsed.toString());
    var localUser;
    if (response.statusCode == 201) {
      localUser = User.fromJson(parsed);
      await setUserPreferences(
          localUser.token,
          localUser.profile,
          localUser.hasPicture,
          localUser.username,
          localUser.email,
          localUser.id,
          []);
      await automaticLogin();
    } else if (response.statusCode == 400) {
      localUser = UserCreation.fromJson(parsed);
    } else if (response.statusCode == 500) {
      localUser = "";
    }
    returnList.add(response.statusCode);
    returnList.add(localUser);
    return returnList;
  }

  Future<void> editUser() {}

  Future<int> signIn(String username, String password) async {
    UserLogin _loginUser = new UserLogin(username, password);
    var data = json.encode(_loginUser);
    String postURL = urlBody + "/users/login/";
    var response = await http.post(Uri.encodeFull(postURL),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    var parsed = json.decode(utf8.decode(response.bodyBytes));
    print(parsed.toString());
    var localUser = User.fromJson(parsed);
    if (response.statusCode == 200) {
      await setUserPreferences(
          localUser.token, localUser.profile, localUser.hasPicture,
          localUser.username, localUser.email, localUser.id, localUser.adverts);
      await automaticLogin();
    }
    return response.statusCode;
  }
}
