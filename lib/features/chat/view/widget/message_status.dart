import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';
import 'package:texol_chat_app/features/chat/model/charging_status_model.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

class MessageStatus extends StatelessWidget {
  const MessageStatus({
    super.key,
    required this.tabs,
  });

  final List<ChargingStatusModel> tabs;

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(3),
      height: 54,
      child: Selector<ChatViewModel, String>(
          selector: (p0, p1) => p1.currentFilter,
          builder: (context, currentFilter, _) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                bool isSelected = tabs[index].status == currentFilter;
                return GestureDetector(
                  onTap: () {
                    final chatViewModel = context.read<ChatViewModel>();
                    chatViewModel.setFilter(tabs[index].status);
                  },
                  child: ChipTheme(
                    data: ChipThemeData(
                      backgroundColor: isSelected
                          ? Colors.black
                          : tabs[index].backgroundColor,
                    ),
                    child: Chip(
                      padding: const EdgeInsets.all(8),
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
            );
          }),
    );
  }
}
