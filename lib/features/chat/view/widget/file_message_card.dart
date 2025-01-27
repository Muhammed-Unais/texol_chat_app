import 'package:flutter/material.dart';
import 'package:texol_chat_app/features/chat/view/widget/order_list_message_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FileMessageCard extends StatelessWidget {
  final String filePath;
  final String fileName;
  final String sender;
  final bool asOrder;
  final DateTime timestamp;

  const FileMessageCard({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.sender,
    required this.asOrder,
    required this.timestamp,
  });

  void _openFile(BuildContext context) async {
    final file = File(filePath);
    if (await file.exists()) {
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open the file.')),
        );
      }
    } else {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File does not exist.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = sender == 'me';
    String formattedTime =
        "${timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12}.${timestamp.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
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
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  size: 40,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _openFile(context),
                ),
              ],
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
        ),
      ),
    );
  }
}
