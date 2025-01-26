import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/enums.dart';
import 'package:texol_chat_app/features/chat/model/message_model.dart';
import 'package:texol_chat_app/features/chat/view/widget/text_message_card.dart';
import 'package:texol_chat_app/features/chat/view/widget/voice_message_card.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.messageTyoe == MessageType.text) {
      return MessageCard(
        text: message.text,
        sender: message.sender,
        timestamp: message.timestamp,
      );
    } else if (message.messageTyoe == MessageType.voice) {
      return _buildVoiceBubble(message);
    } else {
      return _buildFileBubble(message);
    }
  }

  Widget _buildVoiceBubble(Message msg) {
    return VoiceMessageCard(
      sender: message.sender,
      duration: "0.0",
      timestamp: message.timestamp,
    );
  }

  Widget _buildFileBubble(Message msg) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file),
      title: const Text(''),
      subtitle: const Text('Tap to open. Status: ${"msg.status"}'),
      onTap: () {},
    );
  }
}
