import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blur/theme/app_colors.dart';

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
    this.centerTitle = false,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: showBackButton,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.black, AppColors.backgroundDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
      ),
      leadingWidth: showBackButton ? leadingWidth : 0,
      leading: leading != null
          ? Padding(
              padding: EdgeInsets.only(
                left: leadingLeftPadding ?? 0,
                right: leadingRightPadding ?? 0,
              ),
              child: leading,
            )
          : (showBackButton
                ? IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () => context.pop(),
                  )
                : null),
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
    );
  }
}
