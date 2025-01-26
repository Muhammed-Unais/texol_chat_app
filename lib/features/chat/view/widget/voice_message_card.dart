import 'package:flutter/material.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';

class VoiceMessageCard extends StatelessWidget {
  final String sender;
  final bool isRead;
  final String duration;
  final DateTime timestamp;

  const VoiceMessageCard({
    super.key,
    required this.sender,
    required this.duration,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isSender = sender == 'me';

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 184, 218, 245),
          borderRadius: BorderRadius.only(
            topLeft: isSender ? const Radius.circular(18) : Radius.zero,
            topRight: const Radius.circular(18),
            bottomLeft: const Radius.circular(18),
            bottomRight: isSender ? Radius.zero : const Radius.circular(18),
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
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Pallete.whiteColor,
              ),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.play_arrow),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Pallete.whiteColor,
                      inactiveTrackColor: Pallete.whiteColor.withOpacity(.4),
                      thumbColor: Colors.blue,
                      trackHeight: 4,
                      overlayShape: SliderComponentShape.noOverlay,
                      minThumbSeparation: 1,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                    ),
                    child: Slider(
                      value: 0.6,
                      onChanged: (value) {},
                      onChangeEnd: (value) {},
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
