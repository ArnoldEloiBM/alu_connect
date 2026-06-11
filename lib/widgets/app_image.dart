import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Network or local file image with graceful loading + error states.
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

  static bool isLocalPath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('file://')) return true;
    if (path.startsWith('/') || path.startsWith(r'\')) return true;
    return RegExp(r'^[A-Za-z]:\\').hasMatch(path);
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();

    if (!kIsWeb && isLocalPath(url)) {
      final filePath = url.startsWith('file://') ? url.substring(7) : url;
      final file = File(filePath);
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) => _placeholder(
          child: const Center(
            child: Icon(Icons.image_not_supported_outlined,
                color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.gold,
              ),
            ),
          ),
        );
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
