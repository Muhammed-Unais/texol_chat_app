import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:texol_chat_app/features/chat/view_model/chat_view_model.dart';

class BottomChatInput extends StatefulWidget {
  const BottomChatInput({super.key});

  @override
  State<BottomChatInput> createState() => _BottomChatInputState();
}

class _BottomChatInputState extends State<BottomChatInput> {
  late final TextEditingController _textController;
  late final RecorderController _recorderController;
  late ValueNotifier<bool> valueNotifier;
  late final ChatViewModel _chatViewModel;
  late Directory _appDirectory;
  bool _voiceMessageInitited = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _recorderController = RecorderController();
    valueNotifier = ValueNotifier(_recorderController.isRecording);
    _chatViewModel = context.read<ChatViewModel>();
    _initializeAppDirectory();
  }

  Future<void> _initializeAppDirectory() async {
    _appDirectory = await getApplicationDocumentsDirectory();
  }

  Future<void> _startOrStopRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      if (_voiceMessageInitited) {
        await _recorderController.stop(false);
      } else {
        final path =
            '${_appDirectory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
        await _recorderController.record(path: path);
      }
      _voiceMessageInitited = !_voiceMessageInitited;
      _chatViewModel.setVoiceRecordingStatus(_voiceMessageInitited);
      valueNotifier.value = _recorderController.isRecording;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _recorderController.dispose();
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
        child: Selector<ChatViewModel, bool>(
          selector: (p0, p1) => p1.isVoiceRecording,
          builder: (context, isVoiceRecording, _) {
            if (!isVoiceRecording) return _textInputField();
            return _voiceMessageControllers();
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
          onLongPress: _startOrStopRecording,
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

  Widget _voiceMessageControllers() {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
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
                      if (_recorderController.isRecording) {
                        await _recorderController.stop();
                      } else {
                        await _recorderController.record();
                      }

                      valueNotifier.value = _recorderController.isRecording;
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
                    recorderController: _recorderController,
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
                      const Text(
                        '01:25',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            if (!isRecording) ...[
              GestureDetector(
                onTap: () async {
                  if (_recorderController.isRecording) {
                    await _recorderController.stop();
                  } else {
                    await _recorderController.record();
                  }

                  valueNotifier.value = _recorderController.isRecording;
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
              onTap: _startOrStopRecording,
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
