import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final double? leadingLeftPadding;
  final double? leadingRightPadding;
  final double? leadingWidth;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final bool showBackButton;

  const GradientAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.leadingLeftPadding,
    this.leadingWidth,
    this.leadingRightPadding,
    this.actions,
    this.bottom,
    this.centerTitle = true,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.black, // Increased yellow intensity
            AppColors.backgroundDark,
          ],
          begin: FractionalOffset(0.0, 0.0), // Top
          end: FractionalOffset(0.0, 1.0), // Bottom
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: leadingWidth,
        leading: leading != null
            ? Padding(
                padding: EdgeInsets.only(
                  left: leadingLeftPadding ?? 0,
                  right: leadingRightPadding ?? 0,
                ),
                child: leading,
              )
            : null,
        title:
            titleWidget ??
            (title != null
                ? Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null),
        centerTitle: centerTitle,
        actions: actions,
        bottom: bottom,
      ),
    );
  }
}
