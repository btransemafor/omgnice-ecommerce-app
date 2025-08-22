import 'dart:io';

import 'package:flutter/material.dart';

class CommonAvatar extends StatelessWidget {
  final String? imageUrl; // Đường dẫn hoặc URL
  final double radius;
  final String? assetFallback; // Fallback nếu không có ảnh

  const CommonAvatar({
    Key? key,
    this.imageUrl,
    this.radius = 24,
    this.assetFallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (imageUrl == null || imageUrl!.isEmpty) {
      imageProvider = AssetImage(assetFallback ?? 'assets/avatar');
    } else if (imageUrl!.startsWith('http')) {
      // Ảnh Internet
      imageProvider = NetworkImage(imageUrl!);
    } else if (File(imageUrl!).existsSync()) {
      // Ảnh local từ Gallery hoặc Storage
      imageProvider = FileImage(File(imageUrl!));
    } else {
      imageProvider = AssetImage(assetFallback ?? 'assets/avatar');
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: imageProvider,
    );
  }
}
