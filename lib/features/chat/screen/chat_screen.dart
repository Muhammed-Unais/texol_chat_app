import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';
import 'package:texol_chat_app/features/chat/model/charging_status_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentTabIndex = 0;
  final TextEditingController _textController = TextEditingController();
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
          const Expanded(child: SizedBox()),
          _bottomChatField(),
        ],
      ),
    );
  }

  Padding _bottomChatField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0.8,
              spreadRadius: 0.8,
              offset: const Offset(
                0,
                0.5,
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
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
                child: Center(
                  child: Theme(
                    data: ThemeData(
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type here...',
                        suffixIcon: Icon(Icons.file_present_outlined),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 18,
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
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
