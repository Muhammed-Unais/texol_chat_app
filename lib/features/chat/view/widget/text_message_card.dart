import 'package:flutter/material.dart';
import 'package:texol_chat_app/features/chat/view/widget/order_list_message_card.dart';

class TextMessageCard extends StatelessWidget {
  final String text;
  final String sender;
  final DateTime timestamp;
  final bool asOrder;

  const TextMessageCard({
    super.key,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.asOrder,
  });

  @override
  Widget build(BuildContext context) {
    bool isSender = sender == 'me';
    String formattedTime =
        "${timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12}.${timestamp.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSender
              ? Colors.white
              : const Color.fromARGB(255, 184, 218, 245),
          borderRadius: BorderRadius.only(
            topLeft: isSender ? const Radius.circular(12) : Radius.zero,
            topRight: const Radius.circular(12),
            bottomLeft: const Radius.circular(12),
            bottomRight: isSender ? Radius.zero : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                asOrder
                    ? const SizedBox()
                    : Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
            if (asOrder)
              OrderMessageCard(
                isSender: isSender,
                timestamp: timestamp,
              )
          ],
        ),
      ),
    );
  }
}
