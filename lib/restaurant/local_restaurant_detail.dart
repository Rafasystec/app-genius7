import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/pro_rating.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/response/response_local_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class LocalRestaurantDetailScreen extends StatefulWidget {
  final ResponseLocalRestaurant restaurant;
  LocalRestaurantDetailScreen(this.restaurant);
  @override
  _LocalRestaurantDetailScreenState createState() => _LocalRestaurantDetailScreenState();
}

class _LocalRestaurantDetailScreenState extends State<LocalRestaurantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name),),
      body: Column(
        children: <Widget>[

          getItemLocalRestaurantDetail(widget.restaurant),
          Container(
            height: 15,
          ),
          GalleryView(galleryItemsLocal),
          Container(
            height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  appButtonTheme(context, 'VER LOCAL', ()=>openMapsSheet(context),minWidth: 80),
                  SizedBox(width: 20,),
                  appButtonTheme(context, 'VER MENU', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenu(DigitalMenuOptions(2,0)))) ,minWidth: 80),
                ],
              )
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                itemCount: widget.restaurant.ratings == null? 0 : widget.restaurant.ratings.length,
                itemBuilder: (BuildContext context, int index){
                  var item = widget.restaurant.ratings[index];
                  return ProRating(item);
                }),
          ),

        ],
      ),
    );
  }

  openMapsSheet(context) async {
    try {
      final title = "Shanghai Tower";
      final description = "Asia's tallest building";
      final coords = Coords(31.233568, 121.505504);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  List<GalleryExampleItem> galleryItemsLocal = <GalleryExampleItem>[
    GalleryExampleItem(
      id: "tag1",
      resource: "https://img.stpu.com.br/?img=https://s3.amazonaws.com/pu-mgr/default/a0RG000000i1j38MAA/59dcbda8e4b0b478a2d2c683.jpg&w=710&h=462",
    ),
    GalleryExampleItem(id: "tag2", resource: "https://panfleteria.sfo2.digitaloceanspaces.com/img/ofertas/Desconto-Pratos-Parque-Aquatico-ChicoCaranguejo-vr02_5.jpg"),
    GalleryExampleItem(
      id: "tag3",
      resource: "https://www.idasevindasblog.com/wp-content/uploads/2017/08/DSC_1429-1170x775.jpg",
    ),
    GalleryExampleItem(
      id: "tag4",
      resource: "https://static.baratocoletivo.com.br/2019/0411/oferta_15550143112338_Destaque.jpg",
    ),
    GalleryExampleItem(
      id: "tag5",
      resource: "https://fortalezatour.com.br/images/servicos/cc5.jpg",
    ),
  ];

}
