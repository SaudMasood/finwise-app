
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/help/support_chat.dart';
import '../../domain/entities/help/support_messge.dart';
import '../../domain/usecases/help/support_keyword_response.dart';


class SupportRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final SupportKeywordResponder responder;

  SupportRemoteDataSource({
    required this.firestore,
    required this.auth,
    required this.responder,
  });

  String get _uid {
    final user = auth.currentUser;
    if (user == null) {
      throw StateError('Please sign in to use Online Support.');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _chats =>
      firestore
          .collection('support_chats')
          .doc(_uid)
          .collection('chats');

  Stream<List<SupportChat>> watchChats() {
    return _chats
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['updatedAt'] as Timestamp?;

        return SupportChat(
          id: doc.id,
          title: data['title'] as String? ?? 'Support Assistant',
          preview: data['lastMessage'] as String? ?? '',
          updatedAt: timestamp?.toDate() ?? DateTime.now(),
          isActive: data['status'] != 'ended',
        );
      }).toList();
    });
  }

  Stream<List<SupportMessage>> watchMessages(String chatId) {
    return _chats
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timestamp = data['createdAt'] as Timestamp?;

        return SupportMessage(
          id: doc.id,
          text: data['text'] as String? ?? '',
          sender: data['sender'] as String? ?? 'support',
          createdAt: timestamp?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

  Future<String> createChat(String title) async {
    final now = Timestamp.now();

    final chat = await _chats.add({
      'title': title,
      'status': 'active',
      'lastMessage': 'Welcome! I am your virtual assistant.',
      'createdAt': now,
      'updatedAt': now,
    });

    await chat.collection('messages').add({
      'text': 'Welcome! I am your virtual assistant. How can I help you today?',
      'sender': 'support',
      'createdAt': now,
    });

    return chat.id;
  }

  Future<void> sendMessage(String chatId, String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    final chatRef = _chats.doc(chatId);
    final messagesRef = chatRef.collection('messages');

    final chatSnapshot = await chatRef.get();

    if (!chatSnapshot.exists) {
      throw StateError('This support chat does not exist.');
    }

    if (chatSnapshot.data()?['status'] == 'ended') {
      throw StateError('This chat has ended. Start another chat.');
    }

    final reply = responder.getReply(cleanText);
    final now = Timestamp.now();

    // Save both messages and update the chat preview atomically.
    final batch = firestore.batch();

    final userMessage = messagesRef.doc();
    final supportMessage = messagesRef.doc();

    batch.set(userMessage, {
      'text': cleanText,
      'sender': 'user',
      'createdAt': now,
    });

    batch.set(supportMessage, {
      'text': reply,
      'sender': 'support',
      'createdAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(milliseconds: 1)),
      ),
    });

    batch.update(chatRef, {
      'lastMessage': reply,
      'updatedAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(milliseconds: 1)),
      ),
    });

    await batch.commit();
  }

  Future<void> endChat(String chatId) async {
    await _chats.doc(chatId).update({
      'status': 'ended',
      'updatedAt': Timestamp.now(),
    });
  }
}
