import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../const.dart';

class GalleryItem {
  GalleryItem(this.index,{this.id, this.resource, this.isSvg = false,this.isLocal = false});

  final String id;
  final String resource;
  final bool isSvg;
  final bool isLocal;
  final int index;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail(
      {Key key, this.galleryExampleItem, this.onTap})
      : super(key: key);

  final GalleryItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem.id != null ? galleryExampleItem.id : '',
          child: galleryExampleItem.resource != null
              ? !galleryExampleItem.isLocal ? buildCachedNetworkImage() : buildImage()
              : Icon(
            Icons.warning,
            size: 50.0,
            color: greyColor,
          ),
        ),
      ),
    );
  }

  CachedNetworkImage buildCachedNetworkImage() {
    return CachedNetworkImage(
          placeholder: (context, url) => Container(
            child: CircularProgressIndicator(
              strokeWidth: 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
            width: 80.0,
            height: 50.0,
            padding: EdgeInsets.all(15.0),
          ),
          imageUrl: galleryExampleItem.resource,
          width: 120.0,
          height: 120.0,
          fit: BoxFit.cover,
        );
  }
    Widget buildImage() {
    return Container(
            child: Image.file(File(galleryExampleItem.resource)),
            width: 120.0,
            height: 120.0,
            padding: EdgeInsets.all(2.0),
      color: Colors.grey,
          );
  }

}

