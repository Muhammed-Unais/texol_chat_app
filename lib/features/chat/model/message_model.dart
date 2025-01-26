import 'package:texol_chat_app/core/enums.dart';

class Message {
  final String text;
  final String sender;
  final DateTime timestamp;
  final MessageType messageTyoe;
  final String status;

  Message({
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.messageTyoe,
    required this.status,
  });
}
