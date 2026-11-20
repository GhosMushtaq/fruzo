import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Universal image widget that safely renders images across Web, Android, and iOS.
/// Handles assets, local files (Android/iOS), network URLs, and Web blob URLs without assertion errors.
class FruzoImage extends StatelessWidget {
  final String imagePath;
  final bool isAsset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  const FruzoImage({
    super.key,
    required this.imagePath,
    this.isAsset = true,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget defaultPlaceholder() =>
        placeholder ??
        Container(
          width: width,
          height: height,
          color: AppColors.softPeach,
          child: const Center(
            child: Icon(Icons.fastfood_rounded, color: AppColors.primaryOrange, size: 28),
          ),
        );

    if (imagePath.isEmpty) {
      return defaultPlaceholder();
    }

    // 1. Asset Image (Both Web and Mobile)
    if (isAsset || imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => defaultPlaceholder(),
      );
    }

    // 2. Web or Network Image (Blob URL, HTTP, HTTPS, or Data URI)
    if (kIsWeb ||
        imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('blob:') ||
        imagePath.startsWith('data:')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => defaultPlaceholder(),
      );
    }

    // 3. Mobile native File (Android / iOS)
    try {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => defaultPlaceholder(),
      );
    } catch (_) {
      return defaultPlaceholder();
    }
  }
}
