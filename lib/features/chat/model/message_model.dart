import 'package:texol_chat_app/core/enums.dart';

class MessageModel {
  final String id;
  final String sender;
  final DateTime timestamp;
  final MessageType messageTyoe;
  final String status;
  final String content;

  MessageModel({
    required this.sender,
    required this.timestamp,
    required this.messageTyoe,
    required this.status,
    required this.id,
    required this.content,
  });
}
