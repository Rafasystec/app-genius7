import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/restaurant/find_restaurants_and_menu.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenReadQrCode extends StatefulWidget {
  @override
  _ScreenReadQrCodeState createState() => _ScreenReadQrCodeState();
}

class _ScreenReadQrCodeState extends State<ScreenReadQrCode> {
  String barcode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('OPÇÕES'),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Se você já estiver no estabelecimento, basta ler o QR-CODE com o app. Para isso basta pressionar o botão abaixo'),
                appButtonTheme(context,'LER QR-CODE',scan),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(barcode, textAlign: TextAlign.center,),
                ),
                Text('Se preferir, você pode somente pesquisar por algum estabelecimento para visualizar as opções do MENU, lembrando que você só poderá realizar pedidos depois da leitura do QR-CODE'),
                //TODO this option will get to the screen search
                appButtonTheme(context, 'QUERO VER OUTRAS OPÇÕES', ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchForMenusAndRestaurants()))),
              ],
            ),
          ),
        ));
  }

  Future scan() async {
    try {
      var result = await BarcodeScanner.scan();

      setState((){
        if(result != null) {
          this.barcode = result.rawContent;
          //TODO when read, call the firebase to trigger the other smartphone
          //TODO after call the menu for this restaurant
          if(this.barcode.isNotEmpty) {
            var options = DigitalMenuOptions(1, 2, result.rawContent);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenDigitalMenu(options)));
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

}
