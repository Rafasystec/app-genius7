import 'package:app/Objects/waiter_table.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TableDetailScreen extends StatefulWidget {
  final WaiterTable table;
  TableDetailScreen(this.table);
  @override
  _TableDetailScreenState createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends State<TableDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESA ${widget.table.number}'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('Peça para o cliente ler o QR-CODE para iniciar a mesa'),
              Container(
                height: 200,
                width: 200,
                child:QrImage(
                  data: '${widget.table.number}',
                  version: QrVersions.auto,
                  size: 200,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
