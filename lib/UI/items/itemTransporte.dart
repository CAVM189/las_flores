// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemTransporte extends StatelessWidget {
  itemTransporte(
      {required this.un_transporte,
      required this.tapBorrar,
      required this.tapActualizar});

  final transporte un_transporte;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: Text(
            "Tipo: " + un_transporte.tipo,
            style: Theme.of(context).textTheme.headline6,
          ),
          //subtitle: Text(un_dia.Ruta),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(child: Icon(Icons.edit), onTap: tapActualizar),
                GestureDetector(child: Icon(Icons.delete), onTap: tapBorrar)
              ]),
        ));
  }
}
