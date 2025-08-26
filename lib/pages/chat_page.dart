import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/models/chat.dart';
import 'package:testfirebase/models/chat_message.dart';
import 'package:testfirebase/models/chat_user.dart';
import 'package:testfirebase/utils.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';

class ChatPage extends StatefulWidget {
  final MyChatUser chatUser;

  ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthService _authService = GetIt.instance<AuthService>();
  final DatabaseService _databaseService = GetIt.instance<DatabaseService>();
  ChatUser? currentuser, otheruser;
  late bool checkExistChat;
  late String chatID ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentuser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    otheruser = ChatUser(
      id: widget.chatUser.uid,
      firstName: widget.chatUser.name,
    );
    chatID = generateChatID(uid1:  currentuser!.id, uid2: otheruser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatUser.name.toString())),
      body: buildChat( widget.chatUser.uid ,_authService.user!.uid),
    );
  }


  Widget buildChat(String chatID1 ,String chatID2 ) {
    return StreamBuilder<QuerySnapshot<MyChatMessage>>(
      stream: _databaseService.getMessages(chatID1, chatID2),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return const Center(child: Text("هیچ پیامی وجود ندارد"));
        // }

        final docs = snapshot.data!.docs;
        final myMessages = docs.map((d) => d.data()).toList();
        final chatMessages = _generateChatMessagesList(myMessages);

        return DashChat(
          messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
          inputOptions: const InputOptions(alwaysShowSend: true),
          currentUser: currentuser!,
          onSend: (msg) {
            _sendMessage(msg);
          },
          messages: chatMessages,
        );
      },
    );
  }


  List<ChatMessage> _generateChatMessagesList(List<MyChatMessage> messages) {
    List<ChatMessage> returnlist= messages.map((m) {
      return ChatMessage(
        user: m.senderID == currentuser!.id ? currentuser! : otheruser!,
        text: m.content,
        createdAt: m.sentTime,
      );
    }).toList();
    returnlist.sort((a,b){return b.createdAt.compareTo(a.createdAt);});
    return returnlist;
  }

  Future<void> _sendMessage(ChatMessage chatmessage) async {
    try {
      MyChatMessage message = MyChatMessage(
        senderID: currentuser!.id,
        content: chatmessage.text,
        type: MessageType.TEXT,
        sentTime: DateTime.now(),
      );
      await _databaseService.addMessageToChat(chatID , message );
    } catch (e) {
      print(e);
    }
  }

}
