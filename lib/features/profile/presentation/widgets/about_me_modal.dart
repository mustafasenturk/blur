import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/dashed_border_painter.dart';

/// Modal for editing About Me section with biography and voice recording
class AboutMeModal extends StatefulWidget {
  final String? initialBio;
  final String? initialAudioPath;
  final Function(String bio, String? audioPath) onSave;

  const AboutMeModal({
    super.key,
    this.initialBio,
    this.initialAudioPath,
    required this.onSave,
  });

  @override
  State<AboutMeModal> createState() => _AboutMeModalState();
}

class _AboutMeModalState extends State<AboutMeModal>
    with SingleTickerProviderStateMixin {
  static const int maxBioLength = 255;
  static const int maxRecordingSeconds = 30;

  late TextEditingController _bioController;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  int _recordingSeconds = 0;
  int _playbackSeconds = 0;
  Timer? _recordingTimer;
  Timer? _playbackTimer;
  String? _recordedAudioPath;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio ?? '');
    _recordedAudioPath = widget.initialAudioPath;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _audioPlayer.onPlayerComplete.listen((_) {
      _stopPlayback();
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _recorder.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/about_me_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });

      if (_recordingSeconds >= maxRecordingSeconds) {
        _stopRecording();
      }
    });
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    final path = await _recorder.stop();

    setState(() {
      _isRecording = false;
      _recordedAudioPath = path;
    });
  }

  Future<void> _deleteRecording() async {
    if (_recordedAudioPath != null) {
      final file = File(_recordedAudioPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    setState(() {
      _recordedAudioPath = null;
      _recordingSeconds = 0;
    });
  }

  Future<void> _playRecording() async {
    if (_recordedAudioPath == null) return;

    await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));

    setState(() {
      _isPlaying = true;
      _playbackSeconds = 0;
    });

    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _playbackSeconds++;
      });
    });
  }

  void _stopPlayback() {
    _audioPlayer.stop();
    _playbackTimer?.cancel();

    setState(() {
      _isPlaying = false;
      _playbackSeconds = 0;
    });
  }

  void _handleSave() {
    widget.onSave(_bioController.text, _recordedAudioPath);
    Navigator.of(context).pop();
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom +
                16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleSave,
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Biography TextField with dashed border
              Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: DashedBorderPainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                      controller: _bioController,
                      maxLength: maxBioLength,
                      maxLines: 4,
                      cursorColor: AppColors.primary,
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Tell others about yourself...',
                        hintStyle: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(
                          12,
                          12,
                          12,
                          4,
                        ),
                        counterStyle: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Voice Recording Section - Minimalist
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    // Mic Button
                    GestureDetector(
                      onTap: _isRecording
                          ? _stopRecording
                          : (_recordedAudioPath != null
                                ? (_isPlaying ? _stopPlayback : _playRecording)
                                : _startRecording),
                      child: _isRecording
                          ? AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.error.withOpacity(0.2),
                                      border: Border.all(
                                        color: AppColors.error,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.stop,
                                      color: AppColors.error,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _recordedAudioPath != null
                                    ? AppColors.primary.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                              ),
                              child: Icon(
                                _recordedAudioPath != null
                                    ? (_isPlaying
                                          ? Icons.stop
                                          : Icons.play_arrow)
                                    : Icons.mic,
                                color: _recordedAudioPath != null
                                    ? AppColors.primary
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),

                    // Text & Duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isRecording
                                ? 'Recording...'
                                : (_recordedAudioPath != null
                                      ? (_isPlaying
                                            ? 'Playing...'
                                            : 'Voice intro recorded')
                                      : 'Record voice intro'),
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _recordedAudioPath != null
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isRecording || _isPlaying
                                ? _formatDuration(
                                    _isRecording
                                        ? _recordingSeconds
                                        : _playbackSeconds,
                                  )
                                : (_recordedAudioPath != null
                                      ? _formatDuration(_recordingSeconds)
                                      : 'Up to ${maxRecordingSeconds}s'),
                            style: TextStyle(
                              fontFamily: 'RobotoSlab',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delete button if recorded
                    if (_recordedAudioPath != null &&
                        !_isRecording &&
                        !_isPlaying)
                      GestureDetector(
                        onTap: _deleteRecording,
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.white.withOpacity(0.5),
                          size: 22,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
