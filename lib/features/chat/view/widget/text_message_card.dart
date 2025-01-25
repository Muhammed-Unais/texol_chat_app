import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String text;
  final String sender;
  final DateTime timestamp;

  const MessageCard({
    super.key,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isSender = sender == 'me';
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
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
          child: Row(
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
              Text(
                "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
