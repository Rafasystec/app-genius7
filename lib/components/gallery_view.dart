import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/screen_util.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  final List<GalleryExampleItem> galleryItems;
  GalleryView(this.galleryItems);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GalleryExampleItemThumbnail(
                    galleryExampleItem: galleryItems[0] != null ? galleryItems[0] : itemWhenNull,
                    onTap: () {
                      open(context, 0,galleryItems);
                    },
                  ),
                  GalleryExampleItemThumbnail(
                    galleryExampleItem: galleryItems[1] != null ? galleryItems[1] : itemWhenNull,
                    onTap: () {
                      open(context, 1,galleryItems);
                    },
                  ),
                  GalleryExampleItemThumbnail(
                    galleryExampleItem: galleryItems[2] != null ? galleryItems[2] : itemWhenNull,
                    onTap: () {
                      open(context, 2,galleryItems);
                    },
                  ),
                  GalleryExampleItemThumbnail(
                    galleryExampleItem: galleryItems[3] != null ? galleryItems[3] : itemWhenNull,
                    onTap: () {
                      open(context, 3,galleryItems);
                    },
                  ),
                  GalleryExampleItemThumbnail(
                    galleryExampleItem: galleryItems[4] != null ? galleryItems[4] : itemWhenNull,
                    onTap: () {
                      open(context, 4,galleryItems);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  GalleryExampleItem itemWhenNull(){
    return GalleryExampleItem(id: '',resource: '',isSvg: false);
  }

}
