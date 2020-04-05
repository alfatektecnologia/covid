import 'package:flutter/material.dart';

class Carregando extends StatefulWidget {
  @override
  _CarregandoState createState() => _CarregandoState();
}

class _CarregandoState extends State<Carregando> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator()),
        ),
    );
  }
}