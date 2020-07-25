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
        child: Column(
          children: <Widget>[
            getTableDetails(widget.table),
            getTableQRCode(),
            getPartial(),
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
              Center(child: Text(getQRCodeLabelDescription(widget.table))),
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

  String getQRCodeLabelDescription(WaiterTable table){
    String result = 'Peça para o cliente ler o QR-CODE';
    switch(table.status){
      case EnumTableStatus.OPEN :
        result += ' para abrir a mesa.';
        break;
      case EnumTableStatus.BUSY:
        result += ' para gerar uma comanda separada.';
        break;
      case EnumTableStatus.RESERVED:
        result += ' para iniciar a reserva';
        break;
      default :
        result += ' ';
        break;
    }
    return result;
  }

  Widget getTableDetails(WaiterTable table){
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Total até o momento: '),
                Text('R 240,00',style: TextStyle(color: Colors.green, fontSize: 16.0),),
              ],
            ),
            Row(
              children: <Widget>[
                Text('Taxa de serviço (10%): '),
                Text('R 24,00',style: TextStyle(color: Colors.red, fontSize: 16.0),),
              ],
            ),
            Row(
              children: <Widget>[
                Text('Total da mesa: '),
                Text('R 264,00',style: TextStyle(color: Colors.black, fontSize: 18.0),),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getPartial(){
    return Container(
      height: 200,
      child: Center(
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: FlutterLogo(size: 56.0),
                title: Text('Comanda 214'),
                subtitle: Text('Clique aqui para detalhes'),
                trailing: Text('R \$ 100,00'),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                            backgroundImage: NetworkImage('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg'),
                      ),
                title: Text('Comanda 215 - Flávia'),
                subtitle: Text('Clique aqui para detalhes'),
                trailing: Text('R \$ 140,00'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
