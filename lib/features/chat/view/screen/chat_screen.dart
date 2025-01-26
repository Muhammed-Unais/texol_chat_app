import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  OverlayEntry? _overlayEntry;
  Widget? selectedWidget;
  bool _isOverlayVisible = false;

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

  final String orderDetails = '''
Order Details:
- Milk: 5 Packets
- Butter: 5 kg
- Butter: 5 Crates
Order No: 15544
Approved by DP on 2:30 pm, 15/07/2024
  ''';

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        child: Stack(
          children: [
            GestureDetector(
              onTap: _hideOverlay,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.25,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectedWidget!,
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _popupMenu(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Quick Reorder selected"),
                              ));

                              _removeOverlay();
                            },
                            itemName: 'Quick Reorder',
                            icon: Icons.receipt_long_rounded,
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.only(top: 4),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10),
                          _popupMenu(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Assign to Salesmen selected"),
                              ));
                              _removeOverlay();
                            },
                            itemName: 'Assaign to salesman',
                            icon: Icons.airline_stops_rounded,
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.only(top: 4),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10),
                          _popupMenu(
                            onTap: () {
                              Share.share(orderDetails);
                              _removeOverlay();
                            },
                            itemName: 'Share',
                            icon: Icons.share,
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.only(top: 4),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10),
                          _popupMenu(
                            onTap: () {
                              _removeOverlay();
                            },
                            itemName: 'Export',
                            icon: Icons.exposure_outlined,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popupMenu({
    void Function()? onTap,
    required String itemName,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    if (_isOverlayVisible) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    _isOverlayVisible = true;
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
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
          Expanded(
            child: Selector<ChatViewModel, List<MessageModel>>(
              selector: (p0, p1) => p1.filteredMessages,
              builder: (context, messages, _) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final currentWidet = MessageBubble(message: message);

                    return GestureDetector(
                      onLongPress: () {
                        selectedWidget = currentWidet;
                        _showOverlay(context);
                      },
                      child: currentWidet,
                    );
                  },
                );
              },
            ),
          ),
          const BottomChatInput(),
          const SizedBox(height: 5),
          Selector<ChatViewModel, (bool, bool, String?)>(
            selector: (p0, p1) =>
                (p1.isTexting, p1.isVoiceInitiated, p1.fileName),
            builder: (context, value, _) {
              if (value.$1 || value.$2 || value.$3 != null) {
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
              final chatViewModel = context.read<ChatViewModel>();
              chatViewModel.setFilter(tabs[index].status);
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

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
