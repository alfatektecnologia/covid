import 'package:covid19/utilitario/util.dart';
import 'package:flutter/material.dart';

class ShowCards extends StatefulWidget {
  @override
  _ShowCardsState createState() => _ShowCardsState();
}

class _ShowCardsState extends State<ShowCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text('Total de casos:'),
            subtitle: Text(Util.totalCasos.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de novos casos:'),
            subtitle: Text(Util.novosCasos.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de mortes:'),
            subtitle: Text(Util.totalMortes.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de novas mortes:'),
            subtitle: Text(Util.novasMortes.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de curados:'),
            subtitle: Text(Util.totalCurados.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de casos ativos:'),
            subtitle: Text(Util.casosAtivos.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Total de casos graves:'),
            subtitle: Text(Util.casosGraves.toStringAsFixed(0),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Text('oliveiraemanoel.br@gmail.com',style: TextStyle(color:Colors.indigo[300]),)
      ],
    );
  }
}
