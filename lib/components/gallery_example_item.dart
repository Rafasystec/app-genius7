import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../const.dart';

class GalleryExampleItem {
  GalleryExampleItem({this.id, this.resource, this.isSvg = false});

  final String id;
  final String resource;
  final bool isSvg;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail(
      {Key key, this.galleryExampleItem, this.onTap})
      : super(key: key);

  final GalleryExampleItem galleryExampleItem;

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
              ? CachedNetworkImage(
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
            width: 100.0,
            height: 60.0,
            fit: BoxFit.cover,
          )
              : Icon(
            Icons.warning,
            size: 50.0,
            color: greyColor,
          ),
        ),
      ),
    );
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    id: "tag1",
    resource: "https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg",
  ),
  GalleryExampleItem(id: "tag2", resource: "https://www.comidaereceitas.com.br/img/sizeswp/1200x675/2017/12/peixe_assado_recheado.jpg"),
  GalleryExampleItem(
    id: "tag3",
    resource: "https://www.comidaereceitas.com.br/wp-content/uploads/2008/08/peixe_assado.jpg",
  ),
  GalleryExampleItem(
    id: "tag4",
    resource: "https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg",
  ),
  GalleryExampleItem(
    id: "tag5",
    resource: "https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg",
  ),
];
