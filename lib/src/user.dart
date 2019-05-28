import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zigma2/src/chat.dart';
import 'package:zigma2/src/pages/chat_page.dart';

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
  Image profilePic;
  WebSocketChannel myInboxes;
  ChatList chatList;

  User(this.email, this.id, this.username, this.token, this.profile,
      this.hasPicture, this.adverts, this.soldBooks, this.boughtBooks);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson(User json) => _$UserToJson(json);

  void initSocketChannel() {
    if (chatList == null) {
      chatList = ChatList();
    }
    myInboxes = IOWebSocketChannel.connect(
        'ws://5aea970b.ngrok.io/ws/myinbox/',
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Token " + token
        });
    myInboxes.stream.listen((data) async {
      Message messageText = Message.fromJson(json.decode(data));
      if (identical(messageText.receivingUser, username)) {
      if (!chatList.getChattingUserList ()
          .contains(messageText.username)) {
      User tempUser = await getUserByUsername(messageText.username);
      Chat newChat = Chat(chattingUser: tempUser);
      newChat.chatMessages.insert(0, messageText);
      chatList.chatList.insert(0, newChat);
      } else {
      for (Chat chat in chatList.chatList) {
      if (chat.chattingUser.username == messageText.username) {
      chat.chatMessages.insert(0, messageText);
      break;
      }
      }
      }
      }
      else {

      }
      });
  }

  Future<User> getUserByUsername(String username) async {
    final String url = 'https://5aea970b.ngrok.io/users/users/' + username;
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(utf8.decode(req.bodyBytes));
    User user = User.fromJson(resBody);
    return user;
  }
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

  UserMethodBody({this.user});

  void iniUser(String email, int id, String username, String token, int profile,
      bool hasPicture, List<int> adverts) {
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

  Image getImage() {
    return user.profilePic;
  }

  String picUrl(int id) {
    print("IM IN PICURL");
    String url = urlBody + "/users/profile_pic/" + id.toString() + "/";
    if (user != null && user.profile == id) {
      user.profilePic = Image.network(url);
    }
    print(url);
    return url;
  }

  Future<void> logout(context) async {
    user = null;
    await clearPrefs();
  }

  Future<void> setUserPreferences(String token, int profile, bool hasPicture,
      String username, String email, int id, List adverts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setInt("profile", profile);
    prefs.setBool("hasPicture", hasPicture);
    prefs.setString("username", username);
    prefs.setString("email", email);
    prefs.setInt("id", id);
    prefs.setStringList("adverts", adverts.map((i) => i.toString()).toList());
  }

  Future<void> setTutorialPrefs(bool _isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("tutorial", _isChecked);
  }

  Future<bool> getTutorialPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("tutorial") != null) {
      return prefs.getBool("tutorial");
    } else
      return false;
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
      picUrl(user.id);
      user.chatList = ChatList();
      user.initSocketChannel();
    }
  }

  Future<List> register(String email, String username, String password,
      String imageAsBytes) async {
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
    Map parsed = json.decode(utf8.decode(response.bodyBytes));
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
    return [response.statusCode, localUser];
  }

  User getUser() => user;

  Future<Map> editAdvert(String header, dynamic edit, int id) async {
    String url = urlBody + "/adverts/adverts/" + id.toString() + "/";
    Map changes = {header: edit};
    var data = json.encode(changes);
    var response = await http.patch(Uri.encodeFull(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + user.token
    });
    if (response.statusCode == 200) {
      return changes;
    } else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  Future<Map> editUser(String header, String edit) async {
    print("IM IN EDIT USER");
    String url = urlBody + "/users/users/" + user.id.toString() + "/";
    print(url);
    Map changes = {header: edit};
    if (header == "username") {
      user.username = changes["username"];
    } else if (header == "email") {
      user.email = changes["email"];
    }
    var data = json.encode(changes);
    var response = await http.patch(Uri.encodeFull(url), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Token " + user.token
    });
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      return changes;
    } else {
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

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
          localUser.token,
          localUser.profile,
          localUser.hasPicture,
          localUser.username,
          localUser.email,
          localUser.id,
          localUser.adverts);
      await automaticLogin();
    }
    picUrl(localUser.id);
    return response.statusCode;
  }
}
