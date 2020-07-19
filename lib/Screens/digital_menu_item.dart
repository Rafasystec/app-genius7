import 'package:app/Objects/category_item.dart';
import 'package:app/Screens/photo_view_gallery.dart';
import 'package:app/components/digital_menu_item.dart';
import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/image_circle.dart';
import 'package:app/components/photo_view_gallery.dart';
import 'package:app/components/pro_rating.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const.dart';

class ScreenDigitalMenuItem extends StatefulWidget {
  final CategoryItem item;
  ScreenDigitalMenuItem(this.item);
  @override
  _ScreenDigitalMenuItemState createState() => _ScreenDigitalMenuItemState();
}

class _ScreenDigitalMenuItemState extends State<ScreenDigitalMenuItem> {
  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes'),),
      body: Container(
        child: Column(

          children: <Widget>[
            getItemDetail(widget.item),
            Container(

              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Expanded(
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
                              galleryExampleItem: galleryItems[0],
                              onTap: () {
                                open(context, 0);
                              },
                            ),
                            GalleryExampleItemThumbnail(
                              galleryExampleItem: galleryItems[1],
                              onTap: () {
                                open(context, 1);
                              },
                            ),
                            GalleryExampleItemThumbnail(
                              galleryExampleItem: galleryItems[2],
                              onTap: () {
                                open(context, 2);
                              },
                            ),
                            GalleryExampleItemThumbnail(
                              galleryExampleItem: galleryItems[3],
                              onTap: () {
                                open(context, 3);
                              },
                            ),
                            GalleryExampleItemThumbnail(
                              galleryExampleItem: galleryItems[4],
                              onTap: () {
                                open(context, 4);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: (){
//                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
                  Fluttertoast.showToast(msg: 'Make order and start chronometer');
                },
                child: Container(
                  decoration: btnBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.send,color: Colors.white),
                        tooltip: 'Ver a agenda do profissional',
                        onPressed: (){
//                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
                        },
                      ),
                      Text('Fazer Pedido',style: TextStyle(color: Colors.white,fontSize: 24.0))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.item.ratings == null? 0 : widget.item.ratings.length,
                  itemBuilder: (BuildContext context, int index){
                    var item = widget.item.ratings[index];
                    return ProRating(item);
                  }),
            ),
          ],
        ),
      ),
    );
  }

}
