import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FullScreenImageViewer extends StatelessWidget {
  final ImageProvider imageProvider;
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageProvider,
    this.heroTag,
  });

  static void show(
    BuildContext context, {
    required ImageProvider imageProvider,
    String? heroTag,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => FullScreenImageViewer(
          imageProvider: imageProvider,
          heroTag: heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dismissible on drag down or tap background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: heroTag != null
                  ? Hero(
                      tag: heroTag!,
                      child: Image(image: imageProvider, fit: BoxFit.contain),
                    )
                  : Image(image: imageProvider, fit: BoxFit.contain),
            ),
          ),

          // Close button
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.buttonBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
