//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testfirebase/models/chat.dart';
import 'package:testfirebase/utils.dart';

//Models
import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "image": _imageURL,
          "last_active": DateTime.now().toUtc(),
          "name": _name,
          "uid":_uid,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getUsersAll(){
    return _db.collection(USER_COLLECTION).snapshots();
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) async{
    Query _query = _db.collection(USER_COLLECTION);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return await _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatID, MyChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            _message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> createChat(String _chatID ) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).set({
        "members": [],           // لیست اعضا
        "created_at": Timestamp.now(), // زمان ایجاد
      });

    } catch (e) {
      print(e);
    }
  }
  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update(
        {
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }



//////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> checkChatExists(String chatID) async {

    try{
      final result = await _db.collection(CHAT_COLLECTION).doc(chatID).get();
      return result.exists;
    }catch(e)
    {
      return false;
    }
  }

  Stream<QuerySnapshot<MyChatMessage>> getMessages(String uid1, String uid2) {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection("messages")
        .orderBy("sent_time", descending: false)
        .withConverter<MyChatMessage>(
      fromFirestore: (snapshot, _) =>
          MyChatMessage.fromJSON(snapshot.data()!),
      toFirestore: (message, _) => message.toJson(),
    )
        .snapshots();
  }






}
