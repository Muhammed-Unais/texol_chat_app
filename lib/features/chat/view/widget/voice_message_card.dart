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
            color: Colors.white,
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.black12,
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
                              activeTrackColor: Colors.black38,
                              inactiveTrackColor:
                                  Pallete.whiteColor.withOpacity(.4),
                              thumbColor: Colors.blue,
                              trackHeight: 4,
                              overlayShape: SliderComponentShape.noOverlay,
                              minThumbSeparation: 1,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8.0,
                              ),
                            ),
                            child: Slider(
                              value: progress,
                              min: 0.0,
                              onChanged: isCurrent
                                  ? (value) {
                                      final position = Duration(
                                          milliseconds: (value *
                                                  totalDuration.inMilliseconds)
                                              .toInt());
                                      audioProvider.seek(position);
                                    }
                                  : null,
                              onChangeEnd: (value) {},
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
                                      "${widget.timestamp.hour}:${widget.timestamp.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
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


// AudioPlayer? _audioPlayer;
//   bool _isPlaying = false;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _initAudio();
//   }

//   Future<void> _initAudio() async {
//     _audioPlayer?.stop();
//     _audioPlayer?.dispose();
//     _audioPlayer = AudioPlayer();
//     try {
//       await _audioPlayer?.setFilePath(widget.content);
//       _duration = _audioPlayer?.duration ?? Duration.zero;

//       _audioPlayer?.positionStream.listen((pos) {
//         setState(() {
//           _position = pos;
//         });
//       });

//       _audioPlayer?.playerStateStream.listen((state) {
//         setState(() {
//           _isPlaying = state.playing;
//           if (state.processingState == ProcessingState.completed) {
//             _isPlaying = false;
//             _audioPlayer?.seek(Duration.zero);
//             _audioPlayer?.pause();
//           }
//         });
//       });
//     } catch (e) {
//       log("$e");
//     }
//   }

//   void _togglePlayPause() {
//     if (_isPlaying) {
//       log(widget.content);
//       _audioPlayer?.pause();
//     } else {
//       _audioPlayer?.play();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _audioPlayer?.dispose();
//     super.dispose();
//   }