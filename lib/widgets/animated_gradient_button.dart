import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const AnimatedGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56.0,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Define the colors for the gradient animation
  final Color _color1 = AppColors.primary; // Gold
  final Color _color2 = const Color(0xFFFFAB91); // Light Orange/Vibe
  final Color _color3 = AppColors.secondary; // Light Yellow

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              gradient: LinearGradient(
                colors: [_color1, _color2, _color3, _color1],
                stops: const [0.0, 0.3, 0.7, 1.0],
                transform: GradientRotation(_animation.value * 2 * 3.14159),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: widget.borderRadius,
                child: Center(child: widget.child),
              ),
            ),
          );
        },
      ),
    );
  }
}
