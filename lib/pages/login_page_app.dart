//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'dart:async';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/foundation.dart';
//
//
//final FirebaseAuth _auth = FirebaseAuth.instance;
//
//class LoginPageApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: "StartPage",
//      home: StartPage(),
//    );
//    §
//  }
//}
//
//class StartPage extends StatefulWidget {
//  @override
//  StartPageState createState() => new StartPageState();
//}
//
//class StartPageState extends State<StartPage> {
//  FirebaseUser user;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('StartPage'),
//      ),
//      body: new Container(
//        margin: const EdgeInsets.symmetric(horizontal: 0.0),
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            new Container(
//              child: RaisedButton(
//                onPressed: () async =>
//                    _pushPage(context, LoginPage()),
//                child: Text('Log in here'),
//              ),
//              padding: const EdgeInsets.all(16),
//              alignment: Alignment.center,
//            ),
//            new Container(
//              child: RaisedButton(
//                onPressed: () async => _pushPage(context, RegisterPage()),
//                child: Text('Register here'),
//              ),
//              padding: const EdgeInsets.all(16),
//              alignment: Alignment.center,
//            ),
//            new Container(
//              child: RaisedButton(
//                onPressed: () {
//                  if (_isLoggedIn()) {
//                    return _pushPage(context, friendlyChatApp());
//                  } else
//                    return null;
//                },
//                child: Text('Enter chatroom'),
//              ),
//              padding: const EdgeInsets.all(16),
//              alignment: Alignment.center,
//            ),
//            new Container(
//              child: RaisedButton(
//                onPressed: () {
//                  print(_auth.toString());
//                },
//                child: Text('Push here'),
//              ),
//              padding: const EdgeInsets.all(16),
//              alignment: Alignment.center,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  bool _isLoggedIn() {
//    print(getCurrentUser());
//    return false;
//  }
//
//  void _pushPage(BuildContext context, Widget page) {
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(builder: (_) => page),
//    );
//  }
//
//  Future<String> getCurrentUser() async {
//    FirebaseUser user = await _auth.currentUser();
//    return user.uid;
//  }
//
//  Future<void> signOut() async {
//    return _auth.signOut();
//  }
//}
//
//class LoginPage extends StatefulWidget {
//  State createState() => new LoginPageState();
//}
//
//class LoginPageState extends State<LoginPage> {
//  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
//  final TextEditingController _userController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  bool _success;
//  String _userName;
//  String _password;
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Authentication Page"),
//        elevation: Theme
//            .of(context)
//            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
//      ),
//      body: new Container(
//        margin: const EdgeInsets.symmetric(horizontal: 0.0),
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            new Form(
//              key: _userKey,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  _showEmailInput(),
//                  _showPasswordInput(),
//                  new RaisedButton(
//                    onPressed: () async {
//                      if (_userKey.currentState.validate()) {
//                        print(_auth.toString());
//                        _userKey.currentState.save();
//                        _signInWithNameAndPassword();
//                      }
//                    },
//                    child: Text('Login'),
//                  ),
//                  new RaisedButton(
//                    onPressed: () async {
//                      if (_userKey.currentState.validate()) {
//                        print(_auth.toString());
//                      }
//                    },
//                    child: Text('Push'),
//                  ),
//                  Container(
//                    alignment: Alignment.center,
//                    child: Text(_success == null
//                        ? ''
//                        : (_success
//                        ? 'Successfully logged in ' + _userName
//                        : 'Login failed')),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _showEmailInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        keyboardType: TextInputType.emailAddress,
//        autofocus: false,
//        decoration: new InputDecoration(
//          hintText: 'Email',
//          icon: new Icon(
//            Icons.mail,
//            color: Colors.grey,
//          ),
//        ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
//        onSaved: (value) => _userName = value,
//      ),
//    );
//  }
//
//  Widget _showPasswordInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        obscureText: true,
//        autofocus: false,
//        decoration: new InputDecoration(
//            hintText: 'Password',
//            icon: new Icon(
//              Icons.lock,
//              color: Colors.grey,
//            )),
//        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
//        onSaved: (value) => _password = value,
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    _userController.dispose();
//    _passwordController.dispose();
//    super.dispose();
//  }
//
//  void _signInWithNameAndPassword() async {
//    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
//      email: _userName,
//      password: _password,
//    );
//    if (user != null) {
//      setState(() {
//        _success = true;
//        _userName = user.email;
//      });
//    } else {
//      _success = false;
//    }
//  }
//}
//
//class RegisterPage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => RegisterPageState();
//}
//
//class RegisterPageState extends State<RegisterPage> {
//  final GlobalKey<FormState> _userKey = GlobalKey<FormState>();
//  final TextEditingController _emailController = TextEditingController();
//  final TextEditingController _passwordController = TextEditingController();
//  bool _success;
//  String _userName;
//  String _password;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Register Page"),
//      ),
//      body: new Container(
//        margin: const EdgeInsets.symmetric(horizontal: 0.0),
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            new Form(
//              key: _userKey,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  _showEmailInput(),
//                  _showPasswordInput(),
//                  new RaisedButton(
//                    onPressed: () async {
//                      if (_userKey.currentState.validate()) {
//                        _userKey.currentState.save();
//                        _registerWithEmailAndPassword();
//                      }
//                    },
//                    child: Text('Login'),
//                  ),
//                  Container(
//                    alignment: Alignment.center,
//                    child: Text(_success == null
//                        ? ''
//                        : (_success
//                        ? 'Successfully registered in ' + _userName
//                        : 'Registration failed')),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _showEmailInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        keyboardType: TextInputType.emailAddress,
//        autofocus: false,
//        decoration: new InputDecoration(
//          hintText: 'Email',
//          icon: new Icon(
//            Icons.mail,
//            color: Colors.grey,
//          ),
//        ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
//        onSaved: (value) => _userName = value,
//      ),
//    );
//  }
//
//  Widget _showPasswordInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
//      child: new TextFormField(
//        maxLines: 1,
//        obscureText: true,
//        autofocus: false,
//        decoration: new InputDecoration(
//            hintText: 'Password',
//            icon: new Icon(
//              Icons.lock,
//              color: Colors.grey,
//            )),
//        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
//        onSaved: (value) => _password = value,
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    _emailController.dispose();
//    _passwordController.dispose();
//    super.dispose();
//  }
//
//  void _registerWithEmailAndPassword() async {
//    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//      email: _userName,
//      password: _password,
//    );
//    if (user != null) {
//      setState(() {
//        _success = true;
//        _userName = user.email;
//      });
//    } else {
//      _success = false;
//    }
//  }
//}
//
//class friendlyChatApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: "FriendlyChat",
//      theme: defaultTargetPlatform == TargetPlatform.iOS
//          ? kIOSTheme
//          : kDefaultTheme,
//      home: new ChatScreen(),
//    );
//  }
//}
//
//class ChatScreen extends StatefulWidget {
//  @override
//  State createState() => new ChatScreenState();
//}
//
//class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//  final List<ChatMessage> _messages = <ChatMessage>[];
//  final TextEditingController _textController = new TextEditingController();
//  bool _isComposing = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Friendlychat"),
//        elevation: Theme
//            .of(context)
//            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
//      ),
//      body: new Container(
//          child: new Column(
//            children: <Widget>[
//              new Flexible(
//                child: new ListView.builder(
//                  padding: new EdgeInsets.all(8.0),
//                  reverse: true,
//                  itemBuilder: (_, int index) => _messages[index],
//                  itemCount: _messages.length,
//                ),
//              ),
//              new Divider(height: 1.0),
//              new Container(
//                decoration: new BoxDecoration(color: Theme
//                    .of(context)
//                    .cardColor),
//                child: _buildTextComposer(),
//              ),
//            ],
//          ),
//          decoration: Theme
//              .of(context)
//              .platform == TargetPlatform.iOS
//              ? new BoxDecoration(
//            border: new Border(
//              top: new BorderSide(color: Colors.grey[200]),
//            ),
//          ) : null
//      ),
//    );
//  }
//
//  Widget _buildTextComposer() {
//    return new IconTheme(
//      data: new IconThemeData(color: Theme
//          .of(context)
//          .accentColor),
//      child: new Container(
//        margin: const EdgeInsets.symmetric(horizontal: 0.0),
//        child: new Row(
//          children: <Widget>[
//            new Flexible(
//              child: new TextField(
//                controller: _textController,
//                onChanged: (String text) {
//                  setState(() {
//                    _isComposing = text.length > 0;
//                  });
//                },
//                onSubmitted: _handleSubmitted,
//                decoration:
//                new InputDecoration.collapsed(hintText: "Send a message"),
//              ),
//            ),
//            new Container(
//                margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                child: Theme
//                    .of(context)
//                    .platform == TargetPlatform.iOS
//                    ? new CupertinoButton(
//                  child: new Text("Send"),
//                  onPressed: _isComposing
//                      ? () => _handleSubmitted(_textController.text)
//                      : null,
//                )
//                    : new IconButton(
//                  icon: new Icon(Icons.send),
//                  onPressed: _isComposing
//                      ? () => _handleSubmitted(_textController.text)
//                      : null,
//                )),
//          ],
//        ),
//      ),
//    );
//  }
//
//  void _handleSubmitted(String text) {
//    _textController.clear();
//    setState(() {
//      _isComposing = false;
//    });
//    ChatMessage message = new ChatMessage(
//      text: text,
//      animationController: new AnimationController(
//        duration: new Duration(milliseconds: 500),
//        vsync: this,
//      ),
//    );
//    setState(() {
//      _messages.insert(0, message);
//    });
//    message.animationController.forward();
//  }
//
//  @override
//  void dispose() {
//    for (ChatMessage message in _messages)
//      message.animationController.dispose();
//    super.dispose();
//  }
//}
//
//
//class ChatMessage extends StatelessWidget {
//  ChatMessage({this.text, this.animationController});
//
//  final String text;
//  final AnimationController animationController;
//
//  @override
//  Widget build(BuildContext context) {
//    return new SizeTransition(
//      sizeFactor: new CurvedAnimation(
//          parent: animationController, curve: Curves.easeOut),
//      axisAlignment: 0.0,
//      child: new Container(
//        margin: const EdgeInsets.symmetric(vertical: 10.0),
//        child: new Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            new Container(
//              margin: const EdgeInsets.only(right: 10.0),
//              child: new CircleAvatar(child: new Text(_name[0])),
//            ),
//            new Expanded(
//              child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  new Text(_name, style: Theme
//                      .of(context)
//                      .textTheme
//                      .subhead),
//                  new Container(
//                    margin: const EdgeInsets.only(top: 5.0),
//                    child: new Text(text),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//const String _name = "Your Name";
//
//final ThemeData kIOSTheme = new ThemeData(
//  primarySwatch: Colors.orange,
//  primaryColor: Colors.grey[100],
//  primaryColorBrightness: Brightness.light,
//);
//
//final ThemeData kDefaultTheme = new ThemeData(
//  primarySwatch: Colors.purple,
//  accentColor: Colors.orangeAccent[400],
//);
//
