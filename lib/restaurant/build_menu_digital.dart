import 'dart:io';

import 'package:app/components/dialog.dart';
import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/response/response_menu_item.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/global_param.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../const.dart';

class BuildDigitalMenuScreen extends StatefulWidget {
//  final Restaurant _restaurant;
//  BuildDigitalMenuScreen(this._restaurant);
  final String refRestaurant,refCategory;
  final bool isEdit;
  final ResponseMenuItem item;
  BuildDigitalMenuScreen(this.refRestaurant,this.refCategory,{this.isEdit = false,this.item});
  @override
  _BuildDigitalMenuScreenState createState() => _BuildDigitalMenuScreenState();
}

class _BuildDigitalMenuScreenState extends State<BuildDigitalMenuScreen> {

  String description, detail,photoUrl;
  int rate = 0;
  double price = 0.0;
  TextEditingController edtDescriptionController;
  TextEditingController edtDetailController;
  TextEditingController edtPriceController;
  final _formKey = GlobalKey<FormState>();
  ImagePicker _picker;
  bool isLoading = false,isLoggedIn = false, showRemoveAll = false;
  List<String> urls = List(), urlsFromDB = List();
  List<File> files = List();
  File avatarImageFile;
  final picker = ImagePicker();
  List<GalleryItem> _galleryItems  = new List();
  GalleryItem _mainImageItem;
  String refItem;


  List<GalleryItem> loadImagesFromStorage(List<String>urls){
    List<GalleryItem> gallery =  List();
    int index = 0;
    for(String url in urls){
        GalleryItem(index, id:(index++).toString(),resource: url,isSvg: false);
      }
      return gallery;
  }
  @override
  void initState() {
    if(widget.isEdit) {
      urlsFromDB = widget.item.urls;
      _galleryItems = getGalleryItems(urlsFromDB);
      photoUrl      = widget.item.icon;
      edtDetailController       = TextEditingController(text: widget.item.detail);
      edtDescriptionController  = TextEditingController(text: widget.item.description);
      edtPriceController        = TextEditingController(text: widget.item.price.toString());
    }else{
      edtDetailController       = TextEditingController();
      edtDescriptionController  = TextEditingController();
      edtPriceController        = TextEditingController();
    }
    _picker = ImagePicker();
    print('Description: ${edtDescriptionController.text}');
    super.initState();
  }
  ///When we need to get image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      avatarImageFile = File(pickedFile.path);
      _mainImageItem = GalleryItem(0,id: 'tagMain',isLocal: true,resource: pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('menu_item').toUpperCase()),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('save')),
            onPressed: () async {
              if(!isLoading) {
                setState(() {
                  isLoading = true;
                });
                handleSaveData();
              }else{
                Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('please_wait'));
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              height: 900,
              child: Column(
                  children : <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 660,
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              height: 660,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Center(
                                    child:
                                    getMainPhotoContainer(avatarImageFile, photoUrl, (){}),
                                  ),
                                  SizedBox(height: 10,),
                                  appButtonTheme(context, AppLocalizations.of(context).translate('add_image'), ()=>addImageGalleryOrCamera(false,null,0),height: 25,),
                                  GalleryView(_galleryItems),
                                  appButtonTheme(context, AppLocalizations.of(context).translate('add_images'), ()=>addImageGalleryOrCamera(false,_galleryItems,5),height: 30,),
                                  formFieldText(AppLocalizations.of(context).translate('meal_name'), (value) {return null;},onChanged: (value){
                                    description = value;
                                  },controller: edtDescriptionController,
                                      maxLength: 25),
                                  formFieldText(AppLocalizations.of(context).translate('details'), (value) {return null;}, onChanged: (value){
                                    detail = value;
                                  },controller: edtDetailController,
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 80
                                  ),
                                  formFieldText('Valor Ex: 55.40',(value) {return null;},onChanged: (value){
                                    if(value != null && value.isNotEmpty) {
                                      price = double.parse(value);
                                    }
                                  },controller: edtPriceController,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      maxLength: 8),
                                  Text(AppLocalizations.of(context).translate('money_explanation')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Container(
                          child: Column(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).translate('cannot_be_undone')),
                              appButtonTheme(context, AppLocalizations.of(context).translate('remove_the_item'),
                                  (){Future.sync(() => onDelete()).then((value){
                                    if(value) {
                                      Firestore.instance
                                          .collection('restaurants/${widget
                                          .refRestaurant}/menu/${widget
                                          .refCategory}/itens').document(
                                          widget.item.id).delete().then((
                                          value) {
                                        Fluttertoast.showToast(
                                            msg: AppLocalizations.of(context)
                                                .translate('item_removed'));
                                        Navigator.pop(context);
                                      });
                                    }
                                  });} ),
                            ],
                          ) ,
                      ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
          // Loading
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
        ],
      )

    );
  }

  Future<bool> onDelete() {
    var value = openDialogYesNo(context,AppLocalizations.of(context).translate('are_you_sure_delete'),title: AppLocalizations.of(context).translate('delete_item'),icon: Icons.cancel);
    return Future.value(value);
  }

  Future addImageGalleryOrCamera(bool fromCamera, List<GalleryItem> galleryItems,int maxImages) async {
    if(galleryItems != null) {
      if (galleryItems.length >= maxImages) {
        Fluttertoast.showToast(msg: '${AppLocalizations.of(context).translate('you_can_just_add')} ${GlobalParameters.maxImageAmount} ${AppLocalizations.of(context).translate('images')}');
        return;
      }
    }
    PickedFile pickerFile ;
    if(fromCamera) {
      pickerFile = await _picker.getImage(source: ImageSource.camera);
    }else{
      pickerFile = await _picker.getImage(source: ImageSource.gallery);
    }
    if (pickerFile != null) {
      File croppedFile = await getCompressedCropImage(pickerFile);
      if(galleryItems != null ) {
        setState(() {
          showRemoveAll = true;
          files.add(croppedFile);
          galleryItems.add(GalleryItem(
            galleryItems.length, id: galleryItems.length.toString(),
            resource: croppedFile.path,
            isSvg: false,
            isLocal: true,));
          //isLoading = true;
        });
      }else{
        setState(() {
          avatarImageFile = croppedFile;
        });
      }
    }
  }

  bool validation(){
    bool result = true;
    var price = edtPriceController.text;
    var description = edtDescriptionController.text;
    var detail = edtDetailController.text;
    if(price == null || price.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_item_price'));
      result = false;
    }else if(description == null || description.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_item_description'));
      result = false;
    }else if(detail == null || detail.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_item_detail'));
      result = false;
    }
    if(widget.isEdit){

    }else{
       if(avatarImageFile == null){
         Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_item_main_image'));
         result = false;
       }
       if(files == null || files.length < 3){
         Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('not_enough_images'));
         result = false;
       }
    }
    return result;
  }

  void handleSaveData() {
    setState(() {
      isLoading = true;
    });
    if(!validation()){
      setState(() {
        isLoading = false;
      });
      return;
    }
    if(widget.isEdit){
      refItem = widget.item.id;
      Firestore.instance
          .collection('restaurants/${widget.refRestaurant}/menu/${widget
          .refCategory}/itens').document(widget.item.id).updateData({
                      'desc'  : edtDescriptionController.text,
                      'detail': edtDetailController.text,
                      'price': double.parse(edtPriceController.text)}).then((value) {
        uploadFile();
        uploadGallery();
        setState(() {
          isLoading = false;
        });
      });

    }else {
      print('Description: ${edtDescriptionController.toString()}');
      Firestore.instance
          .collection('restaurants/${widget.refRestaurant}/menu/${widget
          .refCategory}/itens')
          .add({
        'desc': description,
        'detail': detail,
        'rate': rate,
        'price': price,
        'category': widget.refCategory
      }).then((data) async {
        refItem = data.documentID;
        uploadFile();
        uploadGallery();
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('save_success'));
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  Future uploadFile() async {
    if(avatarImageFile == null)return;
    String fileName = '$COLLECTION_RESTAURANT/${widget.refRestaurant}/menu/$refItem/main.jpg';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('$COLLECTION_RESTAURANT/${widget.refRestaurant}/menu/${widget.refCategory}/itens')
              .document(refItem)
              .updateData({'icon': photoUrl,
            'id': refItem}).then((data) async {
            //await prefs.setString(RESTAURANT_IMG_PATH, photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadGallery() async {
    bool hasError = false;
    if(files == null)return;
    int index = 0;
//    Fluttertoast.showToast(msg: 'Uploading files ...');
    for(File file in files ){
      String fileName = '$COLLECTION_RESTAURANT/${widget.refRestaurant}/menu/$refItem/${++index}_${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}.jpg';
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            String url = downloadUrl;
            Fluttertoast.showToast(msg: 'image $index uploaded!');
            setState(() {
              urls.add(url);
              urlsFromDB.add(url);
            });
            if(urls.length == files.length){
              setState(() {
                isLoading = false;
                if (!hasError) {
                  Firestore.instance
                      .collection('$COLLECTION_RESTAURANT/${widget.refRestaurant}/menu/${widget.refCategory}/itens')
                      .document(refItem)
                      .updateData({'images': urlsFromDB}).then((data) async {
                    setState(() {
                      isLoading = false;
                    });
                    Fluttertoast.showToast(msg: "Upload success");
                  }).catchError((err) {
                    setState(() {
                      isLoading = true;
                    });
                    Fluttertoast.showToast(msg: err.toString());
                  });
                }
              });
            }
          }, onError: (err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: 'This file is not an image');
          });
        } else {
          hasError =true;
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        }
      }, onError: (err) {
        hasError = true;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }
}
