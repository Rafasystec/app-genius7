import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../const.dart';

class PhotoViewGalleryCustom extends StatefulWidget {
  final List<String>  imagesUrl;
  PhotoViewGalleryCustom(this.imagesUrl);
  @override
  _PhotoViewGalleryCustomState createState() => _PhotoViewGalleryCustomState();
}

class _PhotoViewGalleryCustomState extends State<PhotoViewGalleryCustom> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.imagesUrl[index]) ,//AssetImage(widget.galleryItems[index].image),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.1,
//          heroAttributes: HeroAttributes(tag: galleryItems[index].id),
        );
      },
      itemCount: widget.imagesUrl.length,
      loadingBuilder: (context, progress) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            strokeWidth: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
          ),
        ),
      ),
//      backgroundDecoration: widget.backgroundDecoration,
//      pageController: widget.pageController,
//      onPageChanged: onPageChanged,
    );
  }
}
