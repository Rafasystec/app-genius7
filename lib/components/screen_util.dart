
import 'package:app/Screens/photo_view_gallery.dart';
import 'package:app/components/image_circle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../const.dart';
import 'gallery_example_item.dart';

Widget appButtonTheme(BuildContext context,String label, VoidCallback onPressedAction,{double minWidth = 220.0,double height = 70.0, Icon icon} ){
  return ButtonTheme(
    minWidth: minWidth,
    height: height,
    child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: BorderSide(color: Colors.red),
        ),
        onPressed: onPressedAction,
        child: Container(
          width: minWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                  visible: icon != null,
                  child: icon != null ? icon : Icon(Icons.warning)),
              Text(
                label.toUpperCase(),
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        color: Color(0xffdd4b39),
        highlightColor: Color(0xffff7f7f),
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
  );
}

Widget getItemLocalRestaurantDetail(DocumentSnapshot item){
  return Card(
    child: ListTile(
      leading: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: getImageFromURL(item['avatar']),
      ),
      title: Text(item['name']),
      subtitle: Text(item['address'] == null ? 'Sem Endereço ainda':item['address']),
      trailing: Container(
        height: 60,
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('${item['rate']}'),
                Icon(Icons.star,color: Colors.yellowAccent,),
              ],
            ),
            Text('7.4 km',style: TextStyle(color: Colors.green),),
          ],
        ),
      ),
    ),
  );
}

void open(BuildContext context, final int index, List<GalleryItem> galleryItems) {
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

Widget formField(BuildContext context, TextEditingController controller,ValueChanged<String> onChanged,String hint, FocusNode focus){
  return Container(
    child: Theme(
      data: Theme.of(context).copyWith(primaryColor: primaryColor),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.all(5.0),
          hintStyle: TextStyle(color: greyColor),
        ),
        controller: controller,
        onChanged: onChanged,
        focusNode: focus,
      ),
    ),
    margin: EdgeInsets.only(left: 30.0, right: 30.0),
  );
}

Widget formFieldText(String hint,
    FormFieldValidator<String> validator,
    {ValueChanged<String> onChanged,
      TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      int maxLength = 150}){
  return Container(
    child: TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.all(5.0),
        hintStyle: TextStyle(color: greyColor),
      ),
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      maxLines: null,
      maxLength: maxLength,
      keyboardType: keyboardType,
    ),
    margin: EdgeInsets.only(left: 18.0, right: 18.0)
  );
}

String formatCurrency(num value){
  return  'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(value)}';
}

showAlertDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

void finish(BuildContext context){
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    SystemNavigator.pop();
  }
}

