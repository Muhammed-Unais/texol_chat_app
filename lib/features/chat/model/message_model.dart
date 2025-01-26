import 'package:texol_chat_app/core/enums.dart';

class MessageModel {
  final String id;
  final String sender;
  final DateTime timestamp;
  final MessageType messageTyoe;
  final String status;
  final String content;
  final String? duration;
  final String? fileName;
  final bool asOrder;

  MessageModel({
    required this.id,
    required this.sender,
    required this.timestamp,
    required this.messageTyoe,
    required this.status,
    required this.content,
    this.fileName,
    this.duration,
    this.asOrder = false,
  });
  @override
  String toString() {
    return 'MessageModel(id: $id, sender: $sender, timestamp: $timestamp, messageTyoe: $messageTyoe, status: $status, content: $content)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sender == sender &&
        other.timestamp == timestamp &&
        other.messageTyoe == messageTyoe &&
        other.status == status &&
        other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        timestamp.hashCode ^
        messageTyoe.hashCode ^
        status.hashCode ^
        content.hashCode;
  }
}
