import './user.dart';
import './pages/chat_page.dart';

class Chat {
  User thisUser;
  User chattingUser;
  List<ChatMessage> chatMessages = [];

  Chat({this.thisUser, this.chattingUser});

}

class ChatList {
  final List<Chat> chatList = [];
  final List<String> chattingUserList = [];

  void startNewChat(thisUser, newUser) {
    Chat newChat = Chat(thisUser: thisUser, chattingUser: newUser);
    chatList.insert(0, newChat);
    chattingUserList.insert(0, newUser.username);
    print('created a new chat between ' + thisUser.username + ' and ' + newUser.username);

  }
}