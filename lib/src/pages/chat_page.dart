import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:zigma2/src/DataProvider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FriendlyChat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  WebSocketChannel channel;
  TextEditingController _textController;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://3502f4a2.ngrok.io/chat/olle/');
    _textController = TextEditingController();
    channel.stream.listen((data) {
      ChatMessage message = ChatMessage(
        text: data,
        animationController: AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: this,
        ),
      );
      setState(() => _messages.insert(0, message));
      message.animationController.forward();
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  void sendData() {
    if (_textController.text.isNotEmpty) {
      channel.sink.add(_textController.text);
      print('message sink');
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]),
                  ),
                )
              : null),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
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
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => sendData()
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => sendData()
                            : null,
                      )),
          ],
        ),
      ),
    );
  }

}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 50,
                height: 50,
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.fitWidth,
                  placeholder: kTransparentImage,
                  image: DataProvider.of(context).user.getImage(),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(DataProvider.of(context).user.getUsername(),
                      style: Theme.of(context).textTheme.subhead),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);
