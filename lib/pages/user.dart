import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String email;
  int id;
  String username;
  String token;

  User(this.email, this.id, this.token, this.username);

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        username = json['username'],
        id = json['id'],
        token = json['token'];

}

class UserCreation {
  String email;
  String username;
  String password;

  UserCreation(this.email, this.username, this.password);

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'email': email,
  };
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

  void iniUser(String email, int id, String username, String token){
    user = User(email, id, username, token);
  }

  String getToken(){
    return user.token;
  }

  bool checkUser (){
    if (user == null){
      return false;
    }
    else{
      return true;
    }
  }

  bool loggedIn(){
    if(user.token == null){
      return false;
    }
    else{
      return true;
    }
  }

  Future<bool> register(String email, String username, String password) async {
    UserCreation _newUser = new UserCreation(email, username, password);
    var data = json.encode(_newUser);
    print(data);
    String postURL = "https://fecbb9af.ngrok.io/users/create-user/?format=json";
    var response =  await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    print(json.decode(res));
    Map parsed = json.decode(res);
    print(parsed.toString());
    User localUser = User.fromJson(parsed);
    iniUser(localUser.email, localUser.id, localUser.username, localUser.token);
    print(user);
    if (user != null) {
      return true;
    }
    else {
      return false;
    }
  }


  Future<bool> signIn(String username, String password) async {
    UserLogin _loginUser = new UserLogin(username, password);
    var data = json.encode(_loginUser);
    String postURL = "https://fecbb9af.ngrok.io/users/get-token/?format=json";
    var response = await http.post(Uri.encodeFull(postURL), body: data, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
    final String res = response.body;
    Map parsed = json.decode(res);
    print(parsed.toString());
    User localUser = User.fromJson(parsed);
    iniUser(localUser.email, localUser.id, localUser.username, localUser.token);
    print(user);
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}






