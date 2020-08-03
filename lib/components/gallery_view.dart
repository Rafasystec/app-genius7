import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GalleryView extends StatelessWidget {
  final List<GalleryItem> galleryItems;
  GalleryView(this.galleryItems);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: this.galleryItems.length == 0 ? Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.warning),
              Text('Nenhuma imagem'),
            ],
          )
        ),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildGalleryList(context, galleryItems)
              ),
            ),
          ],
        ),
      ),
    );
  }
  GalleryItem itemWhenNull(){
    return GalleryItem(0,id: '',resource: '',isSvg: false);
  }

}

List<GalleryItem> getGalleryItems(List<String> urls){
  List<GalleryItem> items = List();
  int index = 0;
  for(String url in urls){
    items.add(GalleryItem(
      index,
      id: "tag${++index}",
      resource: url,
    ));
  }
  return items;
}

List<Widget> _buildGalleryList(BuildContext context, List<GalleryItem>  items) {
  List<Widget> lines = []; // this will hold Rows according to available lines
  int index = 0;
  for (var item in items) {
    ++index;
    lines.add(GalleryExampleItemThumbnail(
          galleryExampleItem: item != null ? item : GalleryItem(0,id: '',resource: '',isSvg: false),
          onTap: () {
            open(context, item.index,items);
          },
      ),
    );
  }
  return lines;
}
