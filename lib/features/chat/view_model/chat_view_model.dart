import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:texol_chat_app/core/enums.dart';
import 'package:texol_chat_app/features/chat/model/message_model.dart';

class ChatViewModel extends ChangeNotifier {
  bool _isTexting = false;
  bool _isVoiceInitiated = false;
  bool _isVoiceRecording = false;
  late final TextEditingController _textController;
  List<MessageModel> _messages = [];
  late final RecorderController _recorderController;
  String currentFilter = 'All';
  late Directory _appDirectory;
  String? _filePath;
  MessageType? _fileType;
  String? _fileName;

  List<MessageModel> get messages => _messages;
  bool get isVoiceRecording => _isVoiceRecording;
  bool get isVoiceInitiated => _isVoiceInitiated;
  bool get isTexting => _isTexting;
  String? get filePath => _filePath;
  String? get fileName => _fileName;
  MessageType? get fileType => _fileType;
  RecorderController get recorderController => _recorderController;
  TextEditingController get textController => _textController;
  List<MessageModel> get filteredMessages {
    if (currentFilter == 'All') {
      return _messages;
    } else {
      return _messages.where((m) => m.status == currentFilter).toList();
    }
  }

  void setFilter(String filter) {
    currentFilter = filter;
    notifyListeners();
  }

  void setTextingStatus(String value) {
    if (value.isEmpty) {
      _isTexting = false;
    } else {
      _isTexting = true;
    }
    notifyListeners();
  }

  void setVoiceRecordingStatus(bool isVoice) {
    _isVoiceRecording = isVoice;
    notifyListeners();
  }

  void setVoiceRecordInitiatedStatus(bool isVoiceInitiated) {
    _isVoiceInitiated = isVoiceInitiated;
    notifyListeners();
  }

  Future<void> init() async {
    _recorderController = RecorderController();
    _textController = TextEditingController();
    _appDirectory = await getApplicationDocumentsDirectory();
  }

  Future<void> startOrDeleteRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      if (_recorderController.isRecording) {
        await _recorderController.stop(false);
        setVoiceRecordInitiatedStatus(false);
      } else {
        final path =
            '${_appDirectory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
        await _recorderController.record(path: path);
        setVoiceRecordInitiatedStatus(true);
      }

      setVoiceRecordingStatus(_recorderController.isRecording);
    }
  }

  void sendMessage({bool asOrder = false}) {
    final newMessage = MessageModel(
      asOrder: asOrder,
      sender: 'me',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _textController.text,
      messageTyoe: MessageType.text,
      status: asOrder ? 'Pending' : 'Unread',
      timestamp: DateTime.now(),
    );

    _messages = [newMessage, ..._messages];
    _textController.clear();
    setTextingStatus('');
    notifyListeners();
  }

  Future<void> sendVoiceMesage({bool asOrder = false}) async {
    final path = await _recorderController.stop();

    log("$path");
    // after sending message bottom field ui change is needed
    setVoiceRecordInitiatedStatus(false);
    setVoiceRecordingStatus(_recorderController.isRecording);
    final voiceMessage = MessageModel(
      asOrder: asOrder,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: path ?? '',
      messageTyoe: MessageType.voice,
      status: 'Unread',
      timestamp: DateTime.now(),
      sender: "me",
      duration: _formatDuration(
        _recorderController.recordedDuration,
      ),
    );
    _messages = [voiceMessage, ..._messages];
    notifyListeners();
  }

  Future<void> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      String path = result.files.single.path!;
      String fileName = result.files.single.name;
      String extension = fileName.split('.').last.toLowerCase();

      String fileType;
      if (['jpg', 'jpeg', 'png'].contains(extension)) {
        fileType = 'image';
      } else if (extension == 'pdf') {
        fileType = 'pdf';
      } else {
        fileType = 'file';
      }

      final fileExtType =
          fileType == 'image' ? MessageType.image : MessageType.file;

      _filePath = path;
      _fileType = fileExtType;
      _fileName = fileName;

      notifyListeners();
    } else {
      log("File selection canceled.");
    }
  }

  void deletefile() {
    _fileName = null;
    _filePath = null;
    _fileType = null;
    notifyListeners();
  }

  void sendFile({bool asOrder = false}) async {
    if (_filePath == null) return;
    final fileMessage = MessageModel(
      asOrder: asOrder,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _filePath!,
      messageTyoe: fileType!,
      status: 'Unread',
      timestamp: DateTime.now(),
      sender: "me",
      fileName: fileName,
    );

    _messages = [fileMessage, ..._messages];
    _fileName = null;
    _filePath = null;
    _fileType = null;
    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void disposeViewModel() {
    _textController.dispose();
    _recorderController.dispose();
  }
}
