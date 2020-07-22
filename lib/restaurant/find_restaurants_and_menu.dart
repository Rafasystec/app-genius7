import 'package:app/components/screen_util.dart';
import 'package:app/response/response_local_restaurant.dart';
import 'package:app/response/response_rating.dart';
import 'package:app/restaurant/local_restaurant_detail.dart';
import 'package:flutter/material.dart';

class SearchForMenusAndRestaurants extends StatefulWidget {
  @override
  _SearchForMenusAndRestaurantsState createState() => _SearchForMenusAndRestaurantsState();
}

class _SearchForMenusAndRestaurantsState extends State<SearchForMenusAndRestaurants> {
  List<ResponseLocalRestaurant> restaurants;
  @override
  void initState() {
    //TODO get this list from the firebase
    restaurants = <ResponseLocalRestaurant>[
      ResponseLocalRestaurant(1,'Chico do caranguejo','Rua botelho neto numero 1500 Cambeba - Fortaleza-CE','https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg',5,'7,4 km',
    ratings: <ResponseRating>[
      ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'),
      ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'),
      ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal'),
      ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal'),
      ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal'),
      ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'),
    ]),
      ResponseLocalRestaurant(1,'Flor do Lásio','Rua Atenor Morais 800 Cambeba - Fortaleza-CE','https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg',5,'8,5 km',
          ratings: <ResponseRating>[
            ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'),
            ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'),
            ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal')
          ]),
      ResponseLocalRestaurant(1,'Baião de 10','Av Luis Morais 500 Edson Queiroz - Fortaleza-CE','https://i.ytimg.com/vi/kaCsbllNVcQ/maxresdefault.jpg',5,'12 km',
          ratings: <ResponseRating>[
            ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'),
            ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'),
            ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal')
          ]),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesquisa'),),
      body: Container(
        child: ListView.builder(
          itemCount: restaurants != null ? restaurants.length : 0,
            itemBuilder: (BuildContext context, int index){
              var item = restaurants[index];
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocalRestaurantDetailScreen(item)));
                },
                  child: getItemLocalRestaurantDetail(item)
              );
            }),
      ),
    );
  }
}




