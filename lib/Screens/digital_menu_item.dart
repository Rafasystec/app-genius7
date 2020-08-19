import 'package:app/Objects/category_item.dart';
import 'package:app/components/digital_menu_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/rating_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class ScreenDigitalMenuItem extends StatefulWidget {
  final CategoryItem item;
  ScreenDigitalMenuItem(this.item);
  @override
  _ScreenDigitalMenuItemState createState() => _ScreenDigitalMenuItemState();
}

class _ScreenDigitalMenuItemState extends State<ScreenDigitalMenuItem> {

  bool _isLogged = false;
  SharedPreferences prefs;
  String _userRef = "";
  @override
  void initState() {
    readLocal();
    super.initState();
  }
  void readLocal() async{
    prefs = await SharedPreferences.getInstance();
    _userRef = prefs.getString(USER_REF);
    if(_userRef == null || _userRef.isEmpty){
      setState(() {
        _isLogged = false;
      });
    }else{
      setState(() {
        _isLogged = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes'),),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            getItemDetail(widget.item),
            Container(
              height: 15,
            ),
              GalleryView(getGalleryItems(widget.item.listImagesUrl)),
            Container(
              height: 5,
            ),
//TODO: in later version will enable this functionality. Send a order
//            Visibility(
//              visible:  _isLogged,
//              child: Padding(
//                padding: const EdgeInsets.all(4.0),
//                child: InkWell(
//                  onTap: (){
////                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
//                    Fluttertoast.showToast(msg: 'Make order and start chronometer');
//                  },
//                  child: Container(
//                    decoration: btnBoxDecoration(),
//                    child: Row(
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.send,color: Colors.white),
//                          tooltip: 'Enviar pedido',
//                          onPressed: (){
////                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
//                          },
//                        ),
//                        Text('Fazer Pedido',style: TextStyle(color: Colors.white,fontSize: 24.0))
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection(widget.item.ref+'/reviews').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return const Text('Loading...');
                  return RatingComment(snapshot,widget.item.ref,isLogged: _isLogged,reviewsReference: '${widget.item.ref}/reviews',);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }





}
