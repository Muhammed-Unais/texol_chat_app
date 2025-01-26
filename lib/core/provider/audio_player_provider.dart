import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingPath;
  bool _isPlaying = false;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  String? get currentPlayingPath => _currentPlayingPath;
  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  AudioPlayer get audioPlayer => _audioPlayer;

  AudioPlayerProvider() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      final isPlaying = state.playing;
      final processingState = state.processingState;

      if (processingState == ProcessingState.completed) {
        _isPlaying = false;
        _currentPlayingPath = null;
        _currentPosition = Duration.zero;
        _totalDuration = Duration.zero;
        notifyListeners();
      } else {
        _isPlaying = isPlaying;
        notifyListeners();
      }
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        notifyListeners();
      }
    });
  }

  Future<void> play(String path) async {
    try {
      if (_currentPlayingPath == path) {
        if (_isPlaying) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
      } else {
        await _audioPlayer.stop();
        _currentPlayingPath = path;
        await _audioPlayer.setFilePath(path);
        await _audioPlayer.play();
      }
      _isPlaying = _audioPlayer.playing;
      notifyListeners();
    } catch (e) {
      log(" $e");
    }
  }

  Future<void> seek(Duration position) async {
    if (_currentPlayingPath != null) {
      await _audioPlayer.seek(position);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
