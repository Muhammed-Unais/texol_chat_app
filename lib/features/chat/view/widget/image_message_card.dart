import 'dart:io';
import 'package:flutter/material.dart';

class ImageMessageCard extends StatelessWidget {
  final String imagePath;
  final String sender;

  const ImageMessageCard({
    super.key,
    required this.imagePath,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
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
          color: isSender ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: imageFile.existsSync()
            ? GestureDetector(
                onTap: () {},
                child: Image.file(
                  imageFile,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            : const Text('Image not found'),
      ),
    );
  }
}
