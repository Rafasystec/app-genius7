import 'dart:io';

import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../const.dart';

class BuildDigitalMenuScreen extends StatefulWidget {
  @override
  _BuildDigitalMenuScreenState createState() => _BuildDigitalMenuScreenState();
}

class _BuildDigitalMenuScreenState extends State<BuildDigitalMenuScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  List _cities =
  ["Principal", "Entradas", "Bebidas Geladas", "Sobremesas", "Bebidas Quentes"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  File _image;
  final picker = ImagePicker();
  List<GalleryExampleItem> _galleryItems  = new List(5);
  GalleryExampleItem _mainImageItem;


  List<GalleryExampleItem> loadImagesFromStorage(){
      //TODO change it later to get from firestorage
    return   <GalleryExampleItem>[
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
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    _galleryItems = loadImagesFromStorage();
    //TODO get this from database or rest api
    _mainImageItem = GalleryExampleItem(
      id: "tagMain",
      resource: "https://fortalezatour.com.br/images/servicos/cc5.jpg",
    );
    super.initState();
  }
  ///When we need to get image
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(
          value: city,
          child: new Text(city)
      ));
    }
    return items;
  }


  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Montar ou alterar Menu'),
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
                                SizedBox(height: 15,),
                                Text("Escolha a categoria do Item ", style: TextStyle(fontSize: 16),),
                                Container(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButton(
                                      value: _currentCity,
                                      items: _dropDownMenuItems,
                                      onChanged: changedDropDownItem,
                                    ),
                                    appButtonTheme(context, '+', ()=>Fluttertoast.showToast(msg: 'The deal is open a popup to put the description'),height: 20, minWidth: 60),
                                  ],
                                )
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
                                    open(context, 0,<GalleryExampleItem>[_mainImageItem]);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            appButtonTheme(context, 'ADD IMAGEM PRINCIPAL', getImage,height: 25,minWidth: 60),
                            GalleryView(_galleryItems),
                            appButtonTheme(context, 'ADICIONAR IMAGEMS', getImage,height: 30,minWidth: 60),
                            formFieldText('Nome do prato', (value) {
                              if (value.isEmpty) {
                                return 'Por favor informar o nome do prato';
                              }
                              return null;
                            },),
                            formFieldText('Valor',(value) {
                              if (value.isEmpty) {
                                return 'Please enter some text right here';
                              }
                              return null;
                            }),

                            SizedBox(height: 10,),
                            appButtonTheme(context, 'ADICIONAR ITEM', ()=>
                            {
                              if(_formKey.currentState.validate()){
                                Fluttertoast.showToast(msg: 'Item adicionado')
                              }
                            },height: 30),

                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Text('Minhas categorias'),
              SizedBox(
                height: 200,
                child: ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (BuildContext context, int index){
                      var item = _cities[index];
                      return Container(
                        height: 50,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(item),
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                      Fluttertoast.showToast(msg: 'Edit item $item');
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.edit),
                                  ),
                                  FlatButton(
                                    onPressed: (){
                                      Fluttertoast.showToast(msg: 'Categoria:  $item foi excluida');
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.delete),
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    }),
              )
            ]
          ),
        ),
      ),
    );
  }
}
