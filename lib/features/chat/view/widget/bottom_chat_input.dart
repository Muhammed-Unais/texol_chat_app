import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/core/enums.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

class BottomChatInput extends StatefulWidget {
  const BottomChatInput({super.key});

  @override
  State<BottomChatInput> createState() => _BottomChatInputState();
}

class _BottomChatInputState extends State<BottomChatInput> {
  late final ChatViewModel _chatViewModel;

  @override
  void initState() {
    super.initState();
    _chatViewModel = context.read<ChatViewModel>();
    _chatViewModel.init();
  }

  @override
  void dispose() {
    _chatViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
        child: Selector<ChatViewModel, (bool, String?, MessageType?)>(
          selector: (p0, p1) => (p1.isVoiceInitiated, p1.fileName, p1.fileType),
          builder: (context, values, _) {
            if (values.$1) return _voiceMessageControllers();
            if (values.$2 != null) return _fileField(values.$2, values.$3);
            return _textInputField();
          },
        ),
      ),
    );
  }

  Row _textInputField() {
    return Row(
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
                  onChanged: _chatViewModel.setTextingStatus,
                  controller: _chatViewModel.textController,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        await _chatViewModel.filePick();
                      },
                      child: const Icon(
                        Icons.file_present_outlined,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
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
          onLongPress: _chatViewModel.startOrDeleteRecording,
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
    );
  }

  Row _fileField(
    String? fileName,
    MessageType? fileType,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _chatViewModel.filePick,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Icon(
              fileType == MessageType.file ? Icons.picture_as_pdf : Icons.image,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            fileName ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _chatViewModel.deletefile,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.07),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: const Icon(
              Icons.delete_outline_outlined,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _voiceMessageControllers() {
    return Selector<ChatViewModel, bool>(
      selector: (p0, p1) => p1.isVoiceRecording,
      builder: (context, isRecording, _) {
        return Row(
          children: [
            !isRecording
                ? GestureDetector(
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
                        Icons.keyboard,
                        color: Colors.white,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      final recorderController =
                          _chatViewModel.recorderController;

                      if (recorderController.isRecording) {
                        await recorderController.pause();
                      } else {
                        await recorderController.record();
                      }

                      _chatViewModel.setVoiceRecordingStatus(
                          recorderController.isRecording);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        isRecording ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                    ),
                  ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioWaveforms(
                    size: const Size(double.infinity, 35),
                    recorderController: _chatViewModel.recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.red,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.transparent,
                    ),
                    padding: const EdgeInsets.only(left: 18),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      StreamBuilder(
                        stream:
                            _chatViewModel.recorderController.onCurrentDuration,
                        builder: (context, snapShot) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          double inSeconds = 0;
                          final position = snapShot.data;
                          if (position != null) {
                            inSeconds =
                                position.inSeconds - (position.inMinutes * 60);
                          }

                          return Text(
                            "${position?.inMinutes ?? ''}:${inSeconds > 10 ? inSeconds.toInt() : "0${inSeconds.toInt()}"}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            if (!isRecording) ...[
              GestureDetector(
                onTap: () async {
                  final recorderController = _chatViewModel.recorderController;
                  if (recorderController.isRecording) {
                    await recorderController.pause();
                  } else {
                    await recorderController.record();
                  }
                  _chatViewModel
                      .setVoiceRecordingStatus(recorderController.isRecording);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    isRecording ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            GestureDetector(
              onTap: _chatViewModel.startOrDeleteRecording,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.07),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
