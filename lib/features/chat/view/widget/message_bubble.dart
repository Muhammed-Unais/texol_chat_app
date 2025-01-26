import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/enums.dart';
import 'package:texol_chat_app/features/chat/model/message_model.dart';
import 'package:texol_chat_app/features/chat/view/widget/file_message_card.dart';
import 'package:texol_chat_app/features/chat/view/widget/image_message_card.dart';
import 'package:texol_chat_app/features/chat/view/widget/text_message_card.dart';
import 'package:texol_chat_app/features/chat/view/widget/voice_message_card.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.messageTyoe == MessageType.text) {
      return MessageCard(
        text: message.content,
        sender: message.sender,
        timestamp: message.timestamp,
      );
    } else if (message.messageTyoe == MessageType.voice) {
      return _buildVoiceBubble();
    } else {
      return _buildFileBubble();
    }
  }

  Widget _buildVoiceBubble() {
    return VoiceMessageCard(
      sender: message.sender,
      timestamp: message.timestamp,
      content: message.content,
      duration: message.duration ?? '',
    );
  }

  Widget _buildFileBubble() {
    if (message.messageTyoe == MessageType.image) {
      return ImageMessageCard(
        imagePath: message.content,
        sender: message.sender,
      );
    }
    return FileMessageCard(
      filePath: message.content,
      fileName: message.fileName ?? '',
      sender: message.sender,
    );
  }
}
