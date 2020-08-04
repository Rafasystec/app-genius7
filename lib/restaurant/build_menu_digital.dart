import 'dart:io';

import 'package:app/Objects/category.dart';
import 'package:app/Objects/restaurant.dart';
import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/restaurant/categories.dart';
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
  BuildDigitalMenuScreen(this.refRestaurant,this.refCategory);
  @override
  _BuildDigitalMenuScreenState createState() => _BuildDigitalMenuScreenState();
}

class _BuildDigitalMenuScreenState extends State<BuildDigitalMenuScreen> {

  String description, detail,photoUrl;
  int rate = 0;
  double price = 0.0;

  final _formKey = GlobalKey<FormState>();
  ImagePicker _picker;
  bool isLoading,isLoggedIn, showRemoveAll = false;
  List<String> urls = List();
  List<File> files = List();
  File avatarImageFile;
  final picker = ImagePicker();
  List<GalleryItem> _galleryItems  = new List(5);
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

    //TODO See it later
    _galleryItems = loadImagesFromStorage(List());
    //TODO get this from database or rest api
    _mainImageItem = GalleryItem(0,
      id: "tagMain",
      resource: "https://fortalezatour.com.br/images/servicos/cc5.jpg",

    );
    _picker = ImagePicker();
    super.initState();
  }
  ///When we need to get image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      avatarImageFile = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Montar ou alterar Menu'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('save')),
            onPressed: () async {
              handleSaveData();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
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
                              child: Container(
                                height: 150,
                                width: 150,
                                child: GalleryExampleItemThumbnail(
                                  galleryExampleItem: _mainImageItem,
                                  onTap: () {
                                    open(context, 0,<GalleryItem>[_mainImageItem]);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            appButtonTheme(context, 'ADD IMAGEM PRINCIPAL', ()=>addImageGalleryOrCamera(false,null,0),height: 25,),
                            GalleryView(_galleryItems),
                            appButtonTheme(context, 'ADICIONAR IMAGEMS', ()=>addImageGalleryOrCamera(false,_galleryItems,5),height: 30,),
                            formFieldText('Nome do prato', (value) {
                              if (value.isEmpty) {
                                return 'Por favor informar o nome do prato';
                              }
                              description = value;
                              return null;
                            },),
                            formFieldText('Detalhe', (value) {
                              if (value.isEmpty) {
                                return 'Por favor informar o detalhe0';
                              }
                              description = value;
                              return null;
                            },),
                            formFieldText('Valor Ex: 55.40',(value) {
                              if (value.isEmpty) {
                                return 'Please enter some text right here';
                              }
                              price = value as double;
                              return null;
                            }),

                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ]
          ),
        ),
      ),
    );
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
          isLoading = true;
        });
      }else{
        setState(() {
          avatarImageFile = croppedFile;
        });
      }
    }
  }

  void handleSaveData() {
//    if(!validation()){
//      return;
//    }
    setState(() {
      isLoading = true;
    });
    Firestore.instance
        .collection('restaurants/${widget.refRestaurant}/menu/${widget.refCategory}/itens')
        .add({'desc': description, 'detail': detail, 'rate': rate,'price':price}).then((data) async {
      //refRestaurant = data.documentID;
      //await prefs.setString(RESTAURANT_PATH, refRestaurant);
      refItem = data.documentID;
      uploadFile();
      uploadGallery();
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('save_success'));
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  Future uploadFile() async {
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
    bool isComplete = false;
    int index = 0;
    Fluttertoast.showToast(msg: 'Uploading files ...');
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
            });
            if(urls.length == files.length){
              setState(() {
                isComplete = true;
                isLoading = false;
                if (!hasError) {
                  Firestore.instance
                      .collection('$COLLECTION_RESTAURANT/${widget.refRestaurant}/menu/${widget.refCategory}/itens')
                      .document(refItem)
                      .updateData({'images': urls}).then((data) async {
                    setState(() {
                      isLoading = true;
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
