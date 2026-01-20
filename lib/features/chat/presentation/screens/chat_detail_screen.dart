import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/gradient_app_bar.dart';
import '../widgets/message_interaction_overlay.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

/// Chat detail screen for individual conversations
class ChatDetailScreen extends StatefulWidget {
  final String odaId;

  const ChatDetailScreen({super.key, required this.odaId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  Map<String, dynamic>? _replyingTo;
  Map<String, dynamic>? _editingMessage;

  // Audio Recording State
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
  static const int maxRecordingSeconds = 60;

  // Mock messages for demonstration
  final List<Map<String, dynamic>> _messages = [
    {'id': '1', 'text': 'Hey there! 👋', 'isMe': false, 'time': '10:30 AM'},
    {'id': '2', 'text': 'Hi! How are you?', 'isMe': true, 'time': '10:31 AM'},
    {
      'id': '3',
      'text': "I'm doing great, thanks for asking! What about you?",
      'isMe': false,
      'time': '10:32 AM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isComposing = _messageController.text.trim().isNotEmpty;
      });
    });

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
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _recorder.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_recordedAudioPath == null && _messageController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      if (_editingMessage != null) {
        // Edit existing message
        final index = _messages.indexWhere(
          (m) => m['id'] == _editingMessage!['id'],
        );
        if (index != -1) {
          _messages[index]['text'] = _messageController.text.trim();
        }
        _editingMessage = null;
      } else {
        // Send new message
        final Map<String, dynamic> newMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'isMe': true,
          'time': 'Now',
        };

        if (_recordedAudioPath != null) {
          newMessage['audio'] = _recordedAudioPath;
          newMessage['text'] = 'Audio Message'; // Fallback text
          newMessage['duration'] = _recordingSeconds;
          // Clear audio state but keep file (in real app, upload it)
          // For now we just dereference it from state
          _recordedAudioPath = null;
          _recordingSeconds = 0;
        } else {
          newMessage['text'] = _messageController.text.trim();
        }

        if (_replyingTo != null) {
          newMessage['replyTo'] = {
            'text': _replyingTo!['text'],
            'username': _replyingTo!['isMe'] ? 'You' : 'Gallant Explorer',
          };
          _replyingTo = null;
        }

        _messages.add(newMessage);
      }
    });

    _messageController.clear();
    _isComposing = false; // Reset composing state

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

    // Stop and delete any previous temporary recording
    if (_recordedAudioPath != null) {
      await _deleteRecording();
    }

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/chat_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );

    if (!mounted) return;

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

    if (!mounted) return;

    setState(() {
      _isRecording = false;
      _recordedAudioPath = path;
    });
  }

  Future<void> _deleteRecording() async {
    // Stop playback if happening
    _stopPlayback();

    if (_recordedAudioPath != null) {
      final file = File(_recordedAudioPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    if (!mounted) return;

    setState(() {
      _recordedAudioPath = null;
      _recordingSeconds = 0;
    });
  }

  Future<void> _playRecording() async {
    if (_recordedAudioPath == null) return;

    await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));

    if (!mounted) return;

    setState(() {
      _isPlaying = true;
      _playbackSeconds = 0;
    });

    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
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

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildStandardInputRow() {
    return Row(
      children: [
        // Camera Icon
        GestureDetector(
          onTap: () => _showSendPhotoSheet(context),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white70,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Input Field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.buttonBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextField(
              focusNode: _focusNode,
              controller: _messageController,
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.black87,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.black54,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Send / Mic Button
        GestureDetector(
          onTap: _isComposing ? _sendMessage : _startRecording,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              _isComposing ? Icons.send_rounded : Icons.mic_none_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingRow() {
    return Row(
      children: [
        // Cancel/Delete Icon
        GestureDetector(
          onTap: () async {
            await _stopRecording();
            await _deleteRecording();
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white70,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Recording Status
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.05,
              ), // Slightly lighter background
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  'Recording... ${_formatDuration(_recordingSeconds)}',
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stop Button
        GestureDetector(
          onTap: _stopRecording,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary),
            ),
            child: const Icon(Icons.stop, color: AppColors.primary, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow() {
    return Row(
      children: [
        // Delete Icon
        GestureDetector(
          onTap: _deleteRecording,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white70,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Playback Controls
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                  ),
                  onPressed: _isPlaying ? _stopPlayback : _playRecording,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Text(
                    _isPlaying
                        ? _formatDuration(_playbackSeconds)
                        : _formatDuration(_recordingSeconds),
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Visual waveform placeholder (optional)
                Icon(
                  Icons.graphic_eq,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Send Button
        GestureDetector(
          onTap: _sendMessage,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientAppBar(
        centerTitle: false,
        titleWidget: GestureDetector(
          onTap: () {
            context.pushNamed(
              'user_profile',
              queryParameters: {
                'username': 'Gallant Explorer', // Mock name, should be dynamic
                'userId': widget.odaId,
              },
            );
          },
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/male_avatar.png'),
              ),
              const SizedBox(width: 10),
              const Text(
                'Gallant Explorer', // Mock name
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              context.pushNamed(
                'call_screen',
                queryParameters: {
                  'username': 'Gallant Explorer',
                  'isIncoming': 'false',
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showOptionsSheet(context),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(
          context,
        ).unfocus(), // Close keyboard on background tap
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Input Area
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_replyingTo != null) _buildReplyPreview(),
                  if (_editingMessage != null) _buildEditPreview(),
                  _isRecording
                      ? _buildRecordingRow()
                      : _recordedAudioPath != null
                      ? _buildReviewRow()
                      : _buildStandardInputRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    final reaction = message['reaction'];
    final replyTo = message['replyTo'];
    final isAudio = message.containsKey('audio');
    final isImage = message.containsKey('image');
    final isVideo = message.containsKey('video');

    Widget bubbleContent;
    if (isAudio) {
      bubbleContent = _buildAudioBubble(message, isMe);
    } else if (isImage) {
      bubbleContent = _buildImageBubble(message);
    } else if (isVideo) {
      bubbleContent = _buildVideoBubble(message);
    } else {
      bubbleContent = Text(
        message['text'] as String,
        style: TextStyle(
          fontFamily: 'RobotoSlab',
          fontSize: 15,
          color: isMe ? Colors.black : Colors.white,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      // Add extra padding at bottom if there is a reaction to avoid overlap
      child: Padding(
        padding: EdgeInsets.only(bottom: reaction != null ? 12.0 : 0),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/male_avatar.png'),
              ),
              const SizedBox(width: 8),
            ],
            Stack(
              clipBehavior: Clip.none,
              children: [
                Builder(
                  builder: (bubbleContext) {
                    return GestureDetector(
                      onTap: () => _showOverlay(bubbleContext, message, isMe),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (isImage || isVideo) ? 4 : 16,
                          vertical: (isImage || isVideo) ? 4 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Reply Preview
                            if (replyTo != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: const Border(
                                    left: BorderSide(
                                      color: AppColors.primary,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      replyTo['username'],
                                      style: const TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      replyTo['text'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Main Message Content
                            bubbleContent,

                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  message['time'] as String,
                                  style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 11,
                                    color: isMe
                                        ? Colors.black.withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.done_all,
                                    size: 14,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Reaction Pill
                if (reaction != null)
                  Positioned(
                    bottom: -10,
                    // Reactions on the OTHER side:
                    // If isMe (Right bubble) -> Reaction on Left (left:0) -> Margin 12
                    // If !isMe (Left bubble) -> Reaction on Right (right:0) -> Margin 12
                    left: isMe ? 12 : null,
                    right: isMe ? null : 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttonBackground,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.grey,
                            backgroundImage: AssetImage(reaction['userImage']),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reaction['emoji'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            if (isMe) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioBubble(Map<String, dynamic> message, bool isMe) {
    // Note: In a real app, you would manage playback state for EACH message.
    // Here we will use a simplified stateless UI or repurpose the main player
    // effectively, this requires a more complex state management for multiple players.
    // For this mock, we'll just show the UI.

    final duration = message['duration'] as int? ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.play_arrow_rounded,
          color: isMe ? Colors.black : AppColors.primary,
          size: 32,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fake waveform
              Row(
                children: List.generate(
                  15,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 3,
                    height: 10 + (index % 5) * 4.0,
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.black.withOpacity(0.4)
                          : AppColors.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatDuration(duration),
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isMe ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildImageBubble(Map<String, dynamic> message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        message['image'], // Use asset for mock
        // For real app: message['imageType'] == 'file' ? FileImage(...) : NetworkImage(...)
        fit: BoxFit.cover,
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _buildVideoBubble(Map<String, dynamic> message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            message['thumbnail'] ??
                'assets/images/pleasures/night_drive.png', // Placeholder thumb
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                message['durationString'] ?? '0:15',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoSlab',
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay(
    BuildContext context,
    Map<String, dynamic> message,
    bool isMe,
  ) {
    // Close keyboard if open
    FocusScope.of(context).unfocus();

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: MessageInteractionOverlay(
              message: message,
              isMe: isMe,
              originalOffset: offset,
              originalSize: size,
              onClose: () => Navigator.pop(context),
              onReactionSelected: (emoji) {
                setState(() {
                  // Remove existing reaction if any (simple toggle or replace)
                  message['reaction'] = {
                    'emoji': emoji,
                    // Use mock logic for avatar since we don't have full user obj here
                    'userImage': 'assets/images/male_avatar.png',
                    'username': 'You', // Or the current user's name
                  };
                });
              },
              onReply: () {
                setState(() {
                  _replyingTo = message;
                });
                // Give focus back to input after frame to allow UI updates
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _focusNode.requestFocus();
                });
              },
              // ...
              onEdit: () {
                setState(() {
                  _editingMessage = message;
                  _messageController.text = message['text'];
                  _replyingTo = null; // Clear reply if editing
                });
                // Focus input logic is handled by user interaction primarily,
                // but we can request focus if we had a node.
                // Updating text controller moves cursor to end usually.
              },
              onCopy: () {
                Clipboard.setData(ClipboardData(text: message['text']));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Message copied',
                      style: TextStyle(fontFamily: 'RobotoSlab'),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              onDelete: () {
                setState(() {
                  _messages.removeWhere((m) => m['id'] == message['id']);
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.buttonBackground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _replyingTo!['isMe'] ? 'You' : 'Gallant Explorer',
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _replyingTo!['text'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            onPressed: () => setState(() => _replyingTo = null),
          ),
        ],
      ),
    );
  }

  Widget _buildEditPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.buttonBackground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Editing Message',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _editingMessage!['text'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
            onPressed: () {
              setState(() {
                _editingMessage = null;
                _messageController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  void _showSendPhotoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Send Photo & Video',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Camera Pick
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Gallery Pick
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.lock_outline, color: Colors.white),
              title: const Text(
                'Private Photos',
                style: TextStyle(color: Colors.white, fontFamily: 'RobotoSlab'),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement Private Photos Pick
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chat Options', // Primary Title
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(sheetContext),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.primary, // Primary colorful X
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.flag, color: Colors.white),
              title: const Text(
                'Report User',
                style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _showReasonSheet(
                  context: context,
                  title: 'Reason for Reporting',
                  reasons: [
                    'Inappropriate Content',
                    'Harassment',
                    'Spam',
                    'Fake Profile',
                    'Underage',
                    'Other',
                  ],
                  onReasonSelected: (reason) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Report submitted. Thank you.',
                          style: TextStyle(fontFamily: 'RobotoSlab'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.block, color: Colors.white),
              title: const Text(
                'Block User',
                style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _showReasonSheet(
                  context: context,
                  title: 'Reason for Blocking',
                  reasons: [
                    'Not Interested',
                    'Harassment',
                    'Spam',
                    'Inappropriate Behavior',
                    'Other',
                  ],
                  onReasonSelected: (reason) {
                    _showConfirmationDialog(
                      context: context,
                      title: 'Block User',
                      content:
                          'Are you sure you want to block this user? This will also delete the chat conversation.',
                      confirmText: 'Block',
                      confirmColor: Colors.red,
                      onConfirm: () {
                        // TODO: Implement block logic
                        // Return to chat list
                        context.pop();
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
              title: Text(
                'Delete Chat',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.red.shade400,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _showConfirmationDialog(
                  context: context,
                  title: 'Delete Chat',
                  content:
                      'Are you sure you want to delete this chat conversation?',
                  confirmText: 'Delete',
                  confirmColor: Colors.red,
                  onConfirm: () {
                    // TODO: Implement delete logic
                    // Return to chat list
                    context.pop();
                  },
                );
              },
            ),
            SizedBox(height: MediaQuery.of(sheetContext).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoSlab',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: 'RobotoSlab',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontFamily: 'RobotoSlab'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              onConfirm();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                color: confirmColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoSlab',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReasonSheet({
    required BuildContext context,
    required String title,
    required List<String> reasons,
    required Function(String) onReasonSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext),
                    child: const Icon(Icons.close, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...reasons.map(
              (reason) => ListTile(
                title: Text(
                  reason,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext); // Close sheet
                  onReasonSelected(reason);
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(sheetContext).padding.bottom),
          ],
        ),
      ),
    );
  }
}
