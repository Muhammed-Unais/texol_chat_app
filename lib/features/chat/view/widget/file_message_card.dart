import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FileMessageCard extends StatelessWidget {
  final String filePath;
  final String fileName;
  final String sender;

  const FileMessageCard({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.sender,
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

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
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
      ),
    );
  }
}
