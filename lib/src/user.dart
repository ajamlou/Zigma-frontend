import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String email;
  int id;
  String username;
  String token;
  String image;
  List adverts;
  int soldBooks;

  User(this.email, this.id, this.username, this.token, this.image, this.adverts,
      this.soldBooks);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        id = json['id'],
        token = json['token'],
        image = json['img_link'],
        adverts = json['adverts'],
        soldBooks = json['sold_books'];
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
}

class UserAdvert {
  String username;
  int id;
  String image;
  List<int> adverts;
  int soldBooks;

  UserAdvert(this.username, this.id, this.image, this.adverts, this.soldBooks);

  UserAdvert.fromJson(Map<String, dynamic> json)
      : username = json['owner_username'],
        id = json['owner_id'],
        image = json['img_link'],
        adverts = json['adverts'],
        soldBooks = json['sold_books'];
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

  void iniUser(
      String email, int id, String username, String token, String image) {
    user = User(email, id, username, token, image, [], 0);
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
        "https://9548fc36.ngrok.io/users/user/" + id.toString() + "/";
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

  void logout() {
    user = null;
  }

  User getUser() {
    return user;
  }

  bool checkUser() {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> register(String email, String username, String password,
      String imageAsBytes) async {
    UserCreation _newUser =
        UserCreation(email, username, password, imageAsBytes);
    var data = json.encode(_newUser);
    print(data);
    String postURL = "https://9548fc36.ngrok.io/users/create-user/?format=json";
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
    User localUser = User.fromJson(parsed);
    iniUser(localUser.email, localUser.id, localUser.username, localUser.token,
        localUser.image);
    return response.statusCode;
  }

  Future<int> signIn(String username, String password) async {
    UserLogin _loginUser = new UserLogin(username, password);
    var data = json.encode(_loginUser);
    String postURL = "https://9548fc36.ngrok.io/users/get-token/?format=json";
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
    iniUser(localUser.email, localUser.id, localUser.username, localUser.token,
        localUser.image);
    return response.statusCode;
  }
}
