import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart'; 
import '../services/translation_service.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final User? user = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final messageText = _messageController.text.trim();
    final String currentUid = user?.uid ?? "";
    _messageController.clear();

    try {
      await FirebaseFirestore.instance.collection('chats').add({
        'patientId': currentUid,
        'patientEmail': user?.email,
        'text': messageText,
        'createdAt': FieldValue.serverTimestamp(),
        'isFromAdmin': false,
      });
      // Scroll vers le bas après envoi
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } catch (e) {
      debugPrint("Erreur d'envoi: $e");
    }
  }

  void _playArrivalSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/arrival.mp3'));
    } catch (e) {
      debugPrint("Erreur son: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final trans = Provider.of<TranslationService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Fond gris bleuté très doux
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0056D2), Color(0xFF003D96)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trans.t('chat_title'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Hôpital de Loum - En ligne", style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Petit bandeau informatif
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF0056D2).withOpacity(0.05),
            child: const Text(
              "🔒 Vos échanges sont sécurisés et confidentiels",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('createdAt', descending: true) 
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Erreur : ${snapshot.error}"));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data.containsKey('patientId') && data['patientId'] == user?.uid;
                }).toList();

                if (docs.isEmpty) {
                  return _buildEmptyChat(trans);
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    bool isMe = (data['isFromAdmin'] ?? true) == false;
                    return _buildMessageBubble(
                      data['text'] ?? "",
                      isMe,
                      data['createdAt'] as Timestamp?,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(trans),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(dynamic trans) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            TranslationService.lang == "FR" ? "Posez votre question à un spécialiste" : "Ask a specialist your question",
            style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, Timestamp? time) {
    String formattedTime = time != null 
        ? DateFormat('HH:mm').format(time.toDate()) 
        : DateFormat('HH:mm').format(DateTime.now());

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF10B981) : Colors.white, // Vert vitalité pour l'utilisateur
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text, 
              style: TextStyle(
                fontSize: 15, 
                color: isMe ? Colors.white : const Color(0xFF1E293B),
                height: 1.3,
              )
            ),
            const SizedBox(height: 6),
            Text(
              formattedTime, 
              style: TextStyle(
                fontSize: 10, 
                color: isMe ? Colors.white70 : Colors.grey[400],
                fontWeight: FontWeight.bold,
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(TranslationService trans) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: trans.t('chat_hint'),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Color(0xFF0056D2),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0xFF0056D2), blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}