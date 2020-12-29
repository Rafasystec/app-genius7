import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class CircleImageFromURL extends StatelessWidget {
  final String imageUrl;
  CircleImageFromURL(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? CachedNetworkImage(
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(
          strokeWidth: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
        width: 50.0,
        height: 50.0,
        padding: EdgeInsets.all(15.0),
      ),
      imageUrl: imageUrl,
      width: 80.0,
      height: 50.0,
      fit: BoxFit.cover,
    )
        : Icon(
      Icons.warning,
      size: 50.0,
      color: greyColor,
    );
  }
}
