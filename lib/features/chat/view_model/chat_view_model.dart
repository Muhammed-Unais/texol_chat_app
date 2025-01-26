import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  bool _isTexting = false;
  bool get isTexting => _isTexting;

  bool _isVoiceRecording = false;
  bool get isVoiceRecording => _isVoiceRecording;

  void setTextingStatus(String value) {
    if (value.isEmpty) {
      _isTexting = false;
    } else {
      _isTexting = true;
    }
    notifyListeners();
  }

  void setVoiceRecordingStatus(bool isVoiceRecording) {
    _isVoiceRecording = isVoiceRecording;
    notifyListeners();
  }
}
