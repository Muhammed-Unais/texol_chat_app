import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/enums.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';
import 'package:texol_chat_app/features/chat/model/charging_status_model.dart';
import 'package:texol_chat_app/features/chat/model/message_model.dart';
import 'package:texol_chat_app/features/chat/view/widget/bottom_chat_input.dart';
import 'package:texol_chat_app/features/chat/view/widget/message_bubble.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentTabIndex = 0;

  final List<ChargingStatusModel> tabs = [
    ChargingStatusModel(
      status: "All",
      backgroundColor: Colors.white,
      labelColor: Colors.black,
    ),
    ChargingStatusModel(
      status: "Unread",
      backgroundColor: Colors.grey.shade200,
      labelColor: Colors.black,
    ),
    ChargingStatusModel(
      status: "Approved",
      backgroundColor: Colors.green.shade100,
      labelColor: Colors.green,
    ),
    ChargingStatusModel(
      status: "Declined",
      backgroundColor: Colors.red.shade100,
      labelColor: Colors.red,
    ),
    ChargingStatusModel(
      status: "Pending",
      backgroundColor: Colors.yellow.shade100,
      labelColor: Colors.yellow.shade800,
    ),
  ];

  final List<Message> messages = [
    Message(
      text: "Hello!",
      sender: "me",
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      messageTyoe: MessageType.voice,
      status: 'Unread',
    ),
    Message(
      text: "How are you?",
      sender: "me",
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      messageTyoe: MessageType.text,
      status: 'Unread',
    ),
    Message(
      text: "I'm good, thank you!",
      sender: "other",
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      messageTyoe: MessageType.text,
      status: 'Unread',
    ),
    Message(
      text: "What about you?",
      sender: "other",
      timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
      messageTyoe: MessageType.text,
      status: 'Unread',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 26,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Michael Knight',
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(
            double.infinity,
            1,
          ),
          child: Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      body: Column(
        children: [
          _messageStatus(),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          const BottomChatInput(),
          const SizedBox(height: 5),
          Selector<ChatViewModel, (bool, bool)>(
            selector: (p0, p1) => (p1.isTexting, p1.isVoiceRecording),
            builder: (context, value, _) {
              if (value.$1 || value.$2) {
                return _messageSendingButtons();
              }

              return const SizedBox();
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Row _messageSendingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
        const SizedBox(width: 10),
        Container(
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
                'Send as chat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Container _messageStatus() {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0.5,
            spreadRadius: 0.1,
            offset: const Offset(
              0,
              0.5,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          bool isSelected = index == currentTabIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                currentTabIndex = index;
              });
            },
            child: ChipTheme(
              data: ChipThemeData(
                backgroundColor:
                    isSelected ? Colors.black : tabs[index].backgroundColor,
              ),
              child: Chip(
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
                side: BorderSide.none,
                label: Text(
                  tabs[index].status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Pallete.whiteColor
                        : tabs[index].labelColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
