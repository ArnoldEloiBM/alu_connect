import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Network image with graceful loading + error states, so a missing/slow
/// image never breaks the layout. Used by cards and category tiles.
class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
          ),
        ));
      },
      errorBuilder: (context, error, stack) => _placeholder(
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _placeholder({Widget? child}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceAlt,
      child: child,
    );
  }
}
