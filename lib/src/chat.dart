import './user.dart';
import './pages/chat_page.dart';

class Chat {
  User chattingUser;
  int advertId;
  List<ChatMessage> chatMessages = [];

  Chat({this.chattingUser, this.advertId});

}

class ChatList {
  final List<Chat> chatList = [];
  final List<String> chattingUserList = [];

  void startNewChat(newUser, advertId) {
    Chat newChat = Chat(chattingUser: newUser, advertId: advertId);
    chatList.insert(0, newChat);
    chattingUserList.insert(0, newUser.username);
    print('created a new chat with ' + newUser.username);

  }
}