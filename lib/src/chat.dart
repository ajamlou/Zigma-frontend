import './DataProvider.dart';
import './user.dart';
import './pages/chat_page.dart';

class Chat {
  User thisUser;
  User chattingUser;
  List<ChatMessage> chatMessages = [];

  Chat({this.thisUser, this.chattingUser});

  void addMessage(ChatMessage chatMessage) {
    chatMessages.add(chatMessage);
  }
}

class ChatList {
  final List<Chat> chatList = [];


  void setUser() {
  }
}