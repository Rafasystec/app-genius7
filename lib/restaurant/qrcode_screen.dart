import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  final String refRestaurant;
  QRCodeScreen(this.refRestaurant);
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR-Code'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[

            getTableQRCode(),

          ],
        ),
      ),
    );
  }

  Widget getTableQRCode(){
    return Center(
      child: Container(

        padding: EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//              Center(child: Text(getQRCodeLabelDescription(widget.table))),
              Container(
                height: 200,
                width: 200,
                child:QrImage(
                  data: widget.refRestaurant,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              SizedBox(height: 25,),
              Text(widget.refRestaurant),

            ],
          ),
        ),
      ),
    );
  }

}
