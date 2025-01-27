import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/provider/audio_player_provider.dart';
import 'package:texol_chat_app/core/theme/app_pallete.dart';
import 'package:texol_chat_app/features/chat/view/widget/order_list_message_card.dart';

class VoiceMessageCard extends StatefulWidget {
  final String sender;
  final bool isRead;
  final DateTime timestamp;
  final String content;
  final String duration;
  final bool isOrder;

  const VoiceMessageCard({
    super.key,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
    required this.content,
    required this.duration,
    this.isOrder = false,
  });

  @override
  State<VoiceMessageCard> createState() => _VoiceMessageCardState();
}

class _VoiceMessageCardState extends State<VoiceMessageCard> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = widget.sender == 'me';
    String formattedTime =
        "${widget.timestamp.hour % 12 == 0 ? 12 : widget.timestamp.hour % 12}.${widget.timestamp.minute.toString().padLeft(2, '0')}";

    return Consumer<AudioPlayerProvider>(builder: (context, audioProvider, _) {
      bool isCurrent = audioProvider.currentPlayingPath == widget.content;
      bool isPlaying = isCurrent && audioProvider.isPlaying;

      Duration currentPosition =
          isCurrent ? audioProvider.currentPosition : Duration.zero;
      Duration totalDuration =
          isCurrent ? audioProvider.totalDuration : Duration.zero;

      double progress = totalDuration.inMilliseconds > 0
          ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
          : 0.0;
      return Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: widget.isOrder ? Colors.white : Colors.lightBlue[50],
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
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: widget.isOrder ? Colors.black12 : Colors.white,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await audioProvider.play(widget.content);
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: widget.isOrder
                                  ? Colors.black38
                                  : Colors.white,
                              inactiveTrackColor:
                                  Pallete.whiteColor.withOpacity(.4),
                              thumbColor: Colors.blue,
                              disabledThumbColor: Colors.blue,
                              trackHeight: 4,
                              overlayShape: SliderComponentShape.noOverlay,
                              minThumbSeparation: 1,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8.0,
                              ),
                            ),
                            child: Slider(
                              value: progress,
                              onChanged: isCurrent
                                  ? (value) {
                                      log("Onchanged");
                                      final position = Duration(
                                          milliseconds: (value *
                                                  totalDuration.inMilliseconds)
                                              .toInt());
                                      audioProvider.seek(position);
                                    }
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                isPlaying
                                    ? "${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}"
                                    : widget.duration,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              widget.isOrder
                                  ? const SizedBox()
                                  : Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                              if (isSender && !widget.isOrder) ...[
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
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.isOrder)
                OrderMessageCard(
                  isSender: isSender,
                  timestamp: widget.timestamp,
                )
            ],
          ),
        ),
      );
    });
  }
}
