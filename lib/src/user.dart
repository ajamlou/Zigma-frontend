import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigma2/src/DataProvider.dart';

class User {
  String email;
  int id;
  String username;
  String token;
  String image;
  List adverts;
  int soldBooks;
  int boughtBooks;

  User(this.email, this.id, this.username, this.token, this.image, this.adverts,
      this.soldBooks, this.boughtBooks);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        id = json['id'],
        token = json['token'],
        image = json['img_link'],
        adverts = json['adverts'],
        soldBooks = json['sold_books'],
        boughtBooks = json['bought_books'];
}

class UserCreation {
  String email;
  String username;
  String password;
  String imageAsBytes;

  UserCreation(this.email, this.username, this.password, this.imageAsBytes);

  // om imageAsBytes är null, encode utan den parametern
  Map<String, dynamic> toJson() => imageAsBytes != null
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

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class UserMethodBody {
  User user;

  UserMethodBody(this.user);

  void iniUser(String email, int id, String username, String token,
      String image, List adverts) {
    user = User(email, id, username, token, image, adverts, 0, 0);
  }

  String getToken() {
    return user.token;
  }

  String getEmail() {
    return user.email;
  }

  String getUsername() {
    return user.username;
  }

  Future<User> getUserById(int id) async {
    final String url =
        "https://9548fc36.ngrok.io/users/users/" + id.toString() + "/";
    print("IM IN getUserById wihooo");
    var req = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print("Im finished with the http request");
    var resBody = json.decode(utf8.decode(req.bodyBytes));
    print(resBody.toString());
    User user = User.fromJson(resBody);
    print(user.username);
    return user;
  }

  String getImage() {
    if (user == null) {
      return null;
    } else {
      return user.image;
    }
  }

  Future<void> logout(context) async {
    user = null;
    DataProvider.of(context).advertList.clearUserAdvertList();
    await clearPrefs();
  }

  User getUser() {
    return user;
  }

  List<int> getAdvertIds() {
    return user.adverts;
  }

  bool checkUser() {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> setUserPreferences(String token, String image, String username,
      String email, int id, List adverts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    prefs.setString("image", image);
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
    if (prefs.getString("token") == null) {
    } else {
      iniUser(
          prefs.getString("email"),
          prefs.getInt("id"),
          prefs.getString("username"),
          prefs.getString("token"),
          prefs.getString("image"),
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
    String postURL = "https://9548fc36.ngrok.io/users/users/";
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
      await setUserPreferences(localUser.token, localUser.image,
          localUser.username, localUser.email, localUser.id, []);
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

  Future<int> signIn(String username, String password) async {
    UserLogin _loginUser = new UserLogin(username, password);
    var data = json.encode(_loginUser);
    String postURL = "https://9548fc36.ngrok.io/users/login/";
    var response = await http.post(Uri.encodeFull(postURL),
        body: data,
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    final String res = response.body;
    Map parsed = json.decode(res);
    print(parsed.toString());
    User localUser = User.fromJson(parsed);
    if (response.statusCode == 200) {
      await setUserPreferences(localUser.token, localUser.image,
          localUser.username, localUser.email, localUser.id, localUser.adverts);
      await automaticLogin();
    }
    return response.statusCode;
  }
}
