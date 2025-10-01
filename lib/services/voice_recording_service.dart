import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordingService {
  static const MethodChannel _channel = MethodChannel('voice_recording');
  static const EventChannel _eventChannel = EventChannel(
    'voice_recording_events',
  );

  static StreamSubscription? _recordingSubscription;
  static bool _isRecording = false;
  static String? _currentRecordingPath;

  static Future<bool> requestPermissions() async {
    final microphonePermission = await Permission.microphone.request();
    return microphonePermission == PermissionStatus.granted;
  }

  static Future<bool> hasPermissions() async {
    final microphonePermission = await Permission.microphone.status;
    return microphonePermission == PermissionStatus.granted;
  }

  static Future<String?> startRecording() async {
    try {
      if (!await hasPermissions()) {
        final granted = await requestPermissions();
        if (!granted) {
          throw Exception('Microphone permission denied');
        }
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentRecordingPath = path.join(appDir.path, fileName);

      await _channel.invokeMethod('startRecording', {
        'path': _currentRecordingPath,
      });
      _isRecording = true;

      return _currentRecordingPath;
    } catch (e) {
      print('Error starting recording: $e');
      return null;
    }
  }

  static Future<String?> stopRecording() async {
    try {
      if (!_isRecording) return null;

      final result = await _channel.invokeMethod('stopRecording');
      _isRecording = false;

      final recordingPath = _currentRecordingPath;
      _currentRecordingPath = null;

      return recordingPath;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  static bool get isRecording => _isRecording;

  static Future<void> dispose() async {
    if (_isRecording) {
      await stopRecording();
    }
    await _recordingSubscription?.cancel();
  }
}
