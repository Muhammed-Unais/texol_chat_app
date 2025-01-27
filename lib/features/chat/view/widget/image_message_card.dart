import 'dart:io';
import 'package:flutter/material.dart';
import 'package:texol_chat_app/features/chat/view/widget/order_list_message_card.dart';

class ImageMessageCard extends StatelessWidget {
  final String imagePath;
  final String sender;
  final bool asOrder;
  final DateTime timestamp;

  const ImageMessageCard({
    super.key,
    required this.imagePath,
    required this.sender,
    required this.asOrder,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
    String formattedTime =
        "${timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12}.${timestamp.minute.toString().padLeft(2, '0')}";
    bool isSender = sender == 'me';
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          color: asOrder ? Colors.white : Colors.blue[50],
          borderRadius: BorderRadius.only(
            topLeft: isSender ? const Radius.circular(18) : Radius.zero,
            topRight: const Radius.circular(18),
            bottomLeft: const Radius.circular(18),
            bottomRight: isSender ? Radius.zero : const Radius.circular(18),
          ),
        ),
        child: imageFile.existsSync()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (!asOrder) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (isSender) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.done_all_outlined,
                            size: 12,
                            color: Colors.grey,
                          ),
                        ]
                      ],
                    ),
                  ],
                  if (asOrder)
                    OrderMessageCard(
                      isSender: isSender,
                      timestamp: timestamp,
                    )
                ],
              )
            : const Text('Image not found'),
      ),
    );
  }
}
