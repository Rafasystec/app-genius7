import 'package:app/Objects/category.dart';
import 'package:app/Objects/category_item.dart';
import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu_item.dart';
import 'package:app/Screens/digital_menu_my_orders.dart';
import 'package:app/components/choice.dart';
import 'package:app/components/digital_menu_item.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/components/scroll_parent.dart';
import 'package:app/response/response_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../const.dart';


class ScreenDigitalMenu extends StatefulWidget {
  final DigitalMenuOptions options;
  ScreenDigitalMenu(this.options);
  @override
  _ScreenDigitalMenuState createState() => _ScreenDigitalMenuState();
}

class _ScreenDigitalMenuState extends State<ScreenDigitalMenu> {
  ScrollController _controller;
  List<Choice> menuChoices = const <Choice>[
    const Choice(0,title: 'Pedidos', icon: Icons.bookmark_border),
//    const Choice(1,title: 'Fechar', icon: Icons.close),
//    const Choice(2,title: 'Log out', icon: Icons.exit_to_app),
  ];
  List<Category> _categories;
//  final List<Category> categories = <Category>[
//    Category(1,'Entradas', <CategoryItem>[
//          CategoryItem(1,'058 - PEIXE A CANOA','peixe frito inteiro com arroz, batata frita, baião de 2 e farofa',4,'R\$ 78,50','https://media-cdn.tripadvisor.com/media/photo-s/11/07/1e/74/peixe-frito.jpg',
//          listImagesUrl: <String>[
//            'https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg',
//            'https://www.comidaereceitas.com.br/img/sizeswp/1200x675/2017/12/peixe_assado_recheado.jpg',
//            'https://www.comidaereceitas.com.br/wp-content/uploads/2008/08/peixe_assado.jpg'
//          ],
//          ratings: <ResponseRating>[
//            ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'),
//            ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'),
//            ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal')
//          ]),
//          CategoryItem(2,'041 - MOQUECA DE ARRAIA','Arraia, arroz, farofa e vinagrete',4,'R\$ 55,00','https://i.pinimg.com/originals/c2/6d/99/c26d9959ab5b31aaad424c89eff298a4.jpg'),
//          CategoryItem(3,'066 - RISOTO DE CAMARÃO','Camarão, baião ou arroz, batata frita e acompanha jarra de suco.',4,'R\$ 66,00','https://img.itdg.com.br/tdg/images/recipes/000/015/286/326210/326210_original.jpg?mode=crop&width=710&height=400'),
//          CategoryItem(4,'066 - PEIXADA DO MEIO',',Peixe, Arraia, Camarão, baião ou arroz, batata frita e acompanha jarra de suco.',4,'R\$ 166,00','https://img.itdg.com.br/tdg/images/recipes/000/015/286/326210/326210_original.jpg?mode=crop&width=710&height=400')
//        ]
//    ),
//    Category(2,'Bebidas',
//        <CategoryItem>[
//          CategoryItem(1,'Skol','Cerveja Skol 600 ml',4,'R\$ 8,50','https://seeklogo.com/images/S/Skol-logo-F2B28D2CED-seeklogo.com.png'),
//          CategoryItem(1,'heineken','Cerveja Heineken 600 ml',4,'R\$ 10,50','https://i.pinimg.com/originals/9a/a4/81/9aa481a00d10248313da7d48388125f0.png'),
//          CategoryItem(1,'Original','Cerveja Original 600 ml',4,'R\$ 10,50','https://http2.mlstatic.com/conjunto-6-porta-copos-antarctica-original-em-cortica-D_NQ_NP_889001-MLB7997292315_032015-F.jpg'),
//        ]),
//    Category(3,'Sobremesas',
//        <CategoryItem>[
//          CategoryItem(1,'Pudim de chocolate','pudim cremoso de chocolate',4,'R\$ 20,00','http://www.sabordacidade.com.br/fotos/f11s04s2019s11s50s42.jpg'),
//          CategoryItem(1,'Moranguito','Creme de morango com chantile',4,'R\$ 10,50','https://t2.rg.ltmcdn.com/pt/images/6/3/2/sobremesa_de_morango_para_o_natal_5236_600.jpg'),
//          CategoryItem(1,'Original','Cerveja Original 600 ml',4,'R\$ 10,50','https://http2.mlstatic.com/conjunto-6-porta-copos-antarctica-original-em-cortica-D_NQ_NP_889001-MLB7997292315_032015-F.jpg'),
//        ]),
//  ];


  @override
  void initState() {
    _controller = ScrollController();
//    Future<List<Category>> future = getCategories();
//    future.then((value) => _categories = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENU'),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return menuChoices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body:  StreamBuilder(
        stream: Firestore.instance.collection('restaurants/IHwVo5efFvYETtQuleCF/menu').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            padding: const EdgeInsets.all(2),
            controller: _controller,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot item = snapshot.data.documents[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(item['desc'],style: TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic),),
                  Container(
                    height: 250,
                    child: StreamBuilder(
                      stream: item.reference.collection("itens").snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) return const Text('Loading...');
                        return listCategoryItem(snapshot.data.documents);
                      }
                    ),
                  ),

                ],
              );
            }
          );
        }
      ),
    );
  }

  Widget listCategoryItem(List<DocumentSnapshot> docs){
    return ScrollParent(
      child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (BuildContext context,int index){
            DocumentSnapshot item = docs[index];
            return GestureDetector(
              onTap: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenuItem(categoryItemFromSnapshot(item))));
                //Fluttertoast.showToast(msg: 'Click');
              },
              child: getItemDetail(categoryItemFromSnapshot(item)),
            );
          }
      ),
      controller: _controller,
    ) ;
  }

  CategoryItem categoryItemFromSnapshot(DocumentSnapshot item) => CategoryItem(0,item['desc'],item['detail'],item['rate'],formatCurrency(item['price']),item['icon'],item.reference.path, listImagesUrl: getImagesFromSnapshot(item['images']));

  void onItemMenuPress(Choice choice) {
    if (choice.id == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenuMyOrders()));
    }
  }

  List<String> getImagesFromSnapshot(List<dynamic> list){
    List<String> items = List();
    if(list != null) {
      for (dynamic element in list) {
        items.add(element);
      }
    }
    return items;
  }

//  Future<List<Category> > getCategories() async{
//    QuerySnapshot result = await Firestore.instance.collection('restaurants/IHwVo5efFvYETtQuleCF/menu').getDocuments();
//    List<Category> categoryList = List();
//    if(result.documents.length > 0){
//      List<DocumentSnapshot> categories = result.documents;
//      for(DocumentSnapshot category in categories){
//        var descCategory = category['desc'];
//        QuerySnapshot items = await category.reference.collection("itens").getDocuments();
//        List<CategoryItem> categoryItems = List();
//        if(items.documents.length > 0){
//          List<DocumentSnapshot> itemsDoc = items.documents;
//          for(DocumentSnapshot item in itemsDoc ){
//            var id = 0;
//            var desc = '${item['code']} - ${item['desc']}';
//            var detail = item['detail'];
//            var icon = item['icon'];
//            var price = formatCurrency(item['price']);
//            var rate = item['rate'];
//            categoryItems.add(CategoryItem(0,desc,detail,rate,price,icon)) ;
//          }
//        }
//        categoryList.add(Category(0,descCategory,categoryItems));
//      }
//
//    }
//    return categoryList;
//  }
//  Category(2,'Bebidas',
//  <CategoryItem>[
//      CategoryItem(1,'Skol','Cerveja Skol 600 ml',4,'R\$ 8,50','https://seeklogo.com/images/S/Skol-logo-F2B28D2CED-seeklogo.com.png'),
//      CategoryItem(1,'heineken','Cerveja Heineken 600 ml',4,'R\$ 10,50','https://i.pinimg.com/originals/9a/a4/81/9aa481a00d10248313da7d48388125f0.png'),
//      CategoryItem(1,'Original','Cerveja Original 600 ml',4,'R\$ 10,50','https://http2.mlstatic.com/conjunto-6-porta-copos-antarctica-original-em-cortica-D_NQ_NP_889001-MLB7997292315_032015-F.jpg'),
//  ]),


}
