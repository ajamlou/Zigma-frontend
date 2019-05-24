import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../chat.dart';

class ZigmaChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) => buildChatMenu(context);

  Widget buildChatMenu(context) {
    List<Chat> chatList = DataProvider.of(context).chatList.chatList;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 1.0,
            backgroundColor: Color(0xFFAEDBD3),
            title: Text('Dina aktiva chattar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20)),
            centerTitle: true,
            leading: Container(
              child: IconButton(
                color: Color(0xFFFFFFFF),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            actions: <Widget>[],
          )),
      endDrawer: Icon(Icons.settings),
      body: Container(
          child: chatList.length == 0
              ? Container(
                  child: Text('you aint got no chats \n you sad motherfucker'))
              : ListView.builder(
                  itemBuilder: (context, index) =>
                      chatCardBuilder(chatList[index], context),
                  itemCount: chatList.length,
                )),
    );
  }

  Widget chatCardBuilder(thisChat, context) => GestureDetector(
        onTap: () => DataProvider.of(context)
            .routing
            .routeSpecificChat(context, thisChat),
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(right: 8),
                  height: 100,
                  width: 70,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: thisChat.chattingUser.profilePic == null
                        ? Image.asset('images/profile_pic2.png')
                        : Image.network(thisChat.chattingUser.profilePic),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: thisChat.chatMessages.length == 0
                    ? Text('')
                    : Text(thisChat.chatMessages[0].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
              Expanded(
                flex: 2,
                child: Icon(Icons.remove, color: Colors.red),
              ),
            ]),
          ),
        ),
      );
}

class ChatScreen extends StatefulWidget {
  final Chat thisChat;

  ChatScreen({this.thisChat});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  WebSocketChannel channel;
  TextEditingController _textController;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://79b390be.ngrok.io/ws/chat/bajs/',
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Token " + DataProvider.of(context).user.user.token
        });
    _textController = TextEditingController();
    channel.stream.listen((data) {
      Message messageText = Message.fromJson(json.decode(data));
      ChatMessage message = ChatMessage(
        text: messageText.text,
        animationController: AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: this,
        ),
        profilePic: DataProvider.of(context).user.user.profilePic,
      );
      setState(() => widget.thisChat.chatMessages.insert(0, message));
      message.animationController.forward();
    });
  }

  @override
  void dispose() {
    List<ChatMessage> _messages = widget.thisChat.chatMessages;
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void sendData() {
    Message newMessage;
    if (_textController.text.isNotEmpty) {
      newMessage = Message(
        text: _textController.text,
      );
      ChatMessage message = ChatMessage(
        text: newMessage.text,
        animationController: AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: this,
        ),
        profilePic: DataProvider.of(context).user.user.profilePic,
      );
      channel.sink.add(json.encode(newMessage));
      print('message sink');
      _textController.clear();
      _isComposing = !_isComposing;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> _messages = widget.thisChat.chatMessages;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.transparent),
            elevation: 0.0,
            backgroundColor: Color(0xFFAEDBD3),
            title: Text('Du chattar med ' + widget.thisChat.chattingUser.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                )),
            centerTitle: true,
            leading: Container(
              child: IconButton(
                color: Color(0xFFFFFFFF),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            actions: <Widget>[],
          ),
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: _buildTextComposer(),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(color: Colors.grey[200]),
            ))));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Color(0xFFECA72C)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  color: _isComposing ? Color(0xFFAEDBD3) : Colors.grey,
                  onPressed: _isComposing ? () => sendData() : null,
                )),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.profilePic});

  final Image profilePic;
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 50,
                height: 50,
                child: FittedBox(fit: BoxFit.fitWidth, child: profilePic),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            Expanded(
              child: Card(
                child: ListTile(
                  dense: true,
                  title: Text(DataProvider.of(context).user.user.username,
                      style: TextStyle(color: Color(0xFFECA72C))),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 3.0),
                    child: Text(text, style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  Message({this.text});

  String text;

  Map<String, dynamic> toJson() => {
        'message': text,
      };

  Message.fromJson(Map map) : text = map['message'];
}
