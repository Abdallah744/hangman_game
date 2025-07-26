import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../constants/game_constants.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final Map<String, AudioPlayer> _players = {};
  bool _isMuted = false;
  bool _isInitialized = false;
  final Map<String, Completer<void>> _loadingCompleters = {};

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Configure audio session for proper audio behavior
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
      
      // Preload all audio files
      await Future.wait(GameConstants.audioFiles.entries.map((entry) async {
        _loadingCompleters[entry.key] = Completer<void>();
        final player = AudioPlayer();
        try {
          await player.setAsset(entry.value);
          _players[entry.key] = player;
          _loadingCompleters[entry.key]!.complete();
        } catch (e) {
          if (kDebugMode) {
            print('Failed to load audio file ${entry.key}: $e');
          }
          _loadingCompleters[entry.key]!.completeError(e);
        }
      }));
      
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AudioManager: $e');
      }
      rethrow;
    }
  }

  Future<void> playSound(String soundName) async {
    if (_isMuted || !_players.containsKey(soundName)) return;
    
    try {
      // Wait for the sound to be loaded if it's still loading
      if (_loadingCompleters[soundName] != null) {
        await _loadingCompleters[soundName]!.future;
      }
      
      final player = _players[soundName];
      if (player != null) {
        await player.seek(Duration.zero);
        await player.play();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound $soundName: $e');
      }
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      // Stop all currently playing sounds when muting
      for (final player in _players.values) {
        player.stop();
      }
    }
  }

  bool get isMuted => _isMuted;
  
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    _isInitialized = false;
  }
}
