import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_colors.dart';
import '../services/voice_recording_service.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String) onVoiceRecorded;
  final Function() onVoiceCleared;

  const VoiceRecorderWidget({
    super.key,
    required this.onVoiceRecorded,
    required this.onVoiceCleared,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _audioPath;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _playbackDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _playbackPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _playbackPosition = Duration.zero;
      });
    });
  }

  Future<void> _startRecording() async {
    try {
      final path = await VoiceRecordingService.startRecording();
      if (path != null) {
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        _startDurationTimer();
        widget.onVoiceRecorded(path);
      } else {
        _showErrorSnackBar('Failed to start recording');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await VoiceRecordingService.stopRecording();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        setState(() {
          _audioPath = path;
        });
        widget.onVoiceRecorded(path);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording: $e');
    }
  }

  void _startDurationTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingDuration = Duration(
            seconds: _recordingDuration.inSeconds + 1,
          );
        });
        _startDurationTimer();
      }
    });
  }

  Future<void> _playRecording() async {
    if (_audioPath == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_audioPath!));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to play recording: $e');
    }
  }

  void _clearRecording() {
    setState(() {
      _audioPath = null;
      _recordingDuration = Duration.zero;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
      _isPlaying = false;
    });
    widget.onVoiceCleared();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.notificationBadge,
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    VoiceRecordingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _audioPath != null
              ? AppColors.primaryGreen
              : AppColors.lightText,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Voice recording controls
          Row(
            children: [
              // Record/Stop button
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppColors.notificationBadge
                        : AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Recording status and duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRecording
                          ? 'Recording...'
                          : (_audioPath != null
                                ? 'Voice recorded'
                                : 'Tap to record voice'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _isRecording
                            ? AppColors.notificationBadge
                            : AppColors.primaryText,
                      ),
                    ),
                    if (_audioPath != null || _isRecording) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(
                          _isRecording ? _recordingDuration : _playbackDuration,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Play/Pause button (only show if recording exists)
              if (_audioPath != null) ...[
                GestureDetector(
                  onTap: _playRecording,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Clear button
                GestureDetector(
                  onTap: _clearRecording,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red.shade600,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Playback progress bar (only show if recording exists and is playing)
          if (_audioPath != null && _playbackDuration.inSeconds > 0) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _playbackDuration.inSeconds > 0
                  ? _playbackPosition.inSeconds / _playbackDuration.inSeconds
                  : 0.0,
              backgroundColor: AppColors.lightGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
