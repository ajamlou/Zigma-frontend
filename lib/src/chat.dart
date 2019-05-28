import 'package:zigma2/src/data/user.dart';
import './pages/chat_page.dart';


class Chat {
  User chattingUser;
  List<Message> chatMessages = [];


  Chat({this.chattingUser});

  }


class ChatList {
  final List<Chat> chatList = [];
  final List<String> chattingUserList = [];

  void startNewChat(newUser) {
    Chat newChat = Chat(chattingUser: newUser);
    chatList.insert(0, newChat);
    chattingUserList.insert(0, newUser.username);
    print('created a new chat with ' + newUser.username);

  }
  List<String> getChattingUserList() => chattingUserList;
  }