import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

class MessageSendingButtons extends StatelessWidget {
  const MessageSendingButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            final chatViewModel = context.read<ChatViewModel>();

            if (chatViewModel.isVoiceInitiated) {
              await chatViewModel.sendVoiceMesage();
            } else if (chatViewModel.isTexting) {
              chatViewModel.sendMessage();
            } else if (chatViewModel.filePath != null) {
              chatViewModel.sendFile();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(.1),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.send_outlined,
                  color: Colors.blue,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Send as chat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            final chatViewModel = context.read<ChatViewModel>();

            if (chatViewModel.isVoiceInitiated) {
              await chatViewModel.sendVoiceMesage(asOrder: true);
            } else if (chatViewModel.isTexting) {
              chatViewModel.sendMessage(asOrder: true);
            } else if (chatViewModel.filePath != null) {
              chatViewModel.sendFile(asOrder: true);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.1),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.blinds_closed,
                  color: Colors.green,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Send as order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
