import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class MessageInteractionOverlay extends StatefulWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final Offset originalOffset;
  final Size originalSize;
  final VoidCallback onClose;
  final ValueChanged<String>? onReactionSelected;
  final VoidCallback? onReply;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const MessageInteractionOverlay({
    super.key,
    required this.message,
    required this.isMe,
    required this.originalOffset,
    required this.originalSize,
    required this.onClose,
    this.onReactionSelected,
    this.onReply,
    this.onCopy,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<MessageInteractionOverlay> createState() =>
      _MessageInteractionOverlayState();
}

class _MessageInteractionOverlayState extends State<MessageInteractionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showMoreEmojis = false;

  final List<String> _primaryEmojis = ['❤️', '🔥', '😂', '👍', '😈', '😭'];
  final List<String> _moreEmojis = [
    '🥰',
    '🤝',
    '🎉',
    '🤩',
    '🤔',
    '👀',
    '🤯',
    '🙏',
    '💯',
    '👋',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    // Check available space above
    final double topSpace = widget.originalOffset.dy;
    // Assuming reaction bar height approx 50-60
    final bool showReactionsAbove = topSpace > 100;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blur Background with Dark Overlay
          GestureDetector(
            onTap: _handleClose,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.2), // Dimmed background
              ),
            ),
          ),

          // Content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment(widget.isMe ? 1.0 : -1.0, 0.0),
                  child: child,
                ),
              );
            },
            child: Stack(
              children: [
                // Original Message Clone (Highlighted)
                Positioned(
                  top: widget.originalOffset.dy,
                  left: widget.originalOffset.dx,
                  width: widget.originalSize.width,
                  height: widget.originalSize.height,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isMe
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(widget.isMe ? 16 : 4),
                        bottomRight: Radius.circular(widget.isMe ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message['text'] as String,
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 15,
                            color: widget.isMe ? Colors.black : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message['time'] as String,
                          style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontSize: 11,
                            color: widget.isMe
                                ? Colors.black.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Reaction Bar
                Positioned(
                  top: showReactionsAbove
                      ? widget.originalOffset.dy - 60
                      : widget.originalOffset.dy +
                            widget.originalSize.height +
                            10,
                  left: _calculateHorizontalPosition(context, 340),
                  width: 340,
                  child: Align(
                    alignment: widget.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: _buildReactionBar(),
                  ),
                ),

                // Menu Options
                Positioned(
                  top: showReactionsAbove
                      ? widget.originalOffset.dy +
                            widget.originalSize.height +
                            10
                      : widget.originalOffset.dy +
                            widget.originalSize.height +
                            70,
                  left: _calculateHorizontalPosition(context, 200),
                  width: 200,
                  child: _buildMenuOptions(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateHorizontalPosition(
    BuildContext context,
    double targetWidth,
  ) {
    // Screen width
    final screenWidth = MediaQuery.of(context).size.width;

    double left;
    if (widget.isMe) {
      // Align right edge of menu to right edge of bubble
      // Bubble Right X
      final bubbleRight = widget.originalOffset.dx + widget.originalSize.width;
      left = bubbleRight - targetWidth;
    } else {
      // Align left edge of menu to left edge of bubble
      left = widget.originalOffset.dx;
    }

    // Smart Clamp: Ensure it stays within screen bounds (16px margin)
    return left.clamp(16.0, screenWidth - targetWidth - 16.0);
  }

  Widget _buildReactionBar() {
    return Container(
      // Allow height to adapt
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._primaryEmojis.map((emoji) => _buildEmojiItem(emoji)),
                _buildPlusButton(),
              ],
            ),
          ),
          // Expanded Emojis
          if (_showMoreEmojis) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moreEmojis
                    .map((emoji) => _buildEmojiItem(emoji))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmojiItem(String emoji) {
    return GestureDetector(
      onTap: () {
        widget.onReactionSelected?.call(emoji);
        _handleClose();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildPlusButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMoreEmojis = !_showMoreEmojis;
        });
      },
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _showMoreEmojis ? Icons.keyboard_arrow_up : Icons.add,
          color: Colors.black87,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.buttonBackground,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            icon: Icons.reply,
            label: 'Reply',
            onTap: () {
              _handleClose();
              widget.onReply?.call();
            },
          ),
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.1)),
          _buildMenuItem(
            icon: Icons.copy,
            label: 'Copy',
            onTap: () {
              _handleClose();
              widget.onCopy?.call();
            },
          ),
          if (widget.isMe) ...[
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.1)),
            _buildMenuItem(
              icon: Icons.edit,
              label: 'Edit',
              onTap: () {
                _handleClose();
                widget.onEdit?.call();
              },
            ),
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.1)),
            _buildMenuItem(
              icon: Icons.delete_outline,
              label: 'Delete',
              color: Colors.red.shade400,
              onTap: () {
                _handleClose();
                widget.onDelete?.call();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color ?? Colors.black87),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 14,
                  color: color ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
