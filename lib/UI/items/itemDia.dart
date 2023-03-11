// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemDia extends StatelessWidget {
  itemDia(
      {required this.un_dia,
      required this.tapBorrar,
      required this.tapActualizar,
      required this.tapVer});

  final dia un_dia;
  final VoidCallback tapBorrar, tapActualizar, tapVer;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: GestureDetector(
              child: Text(un_dia.Fecha,
                  style: Theme.of(context).textTheme.headline6),
              onTap: tapVer),
          //title: Text('${un_dia.Total}'),
          //subtitle: Text(un_dia.Ruta),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*GestureDetector(child: Icon(Icons.edit), onTap: tapActualizar),
                GestureDetector(child: Icon(Icons.delete), onTap: tapBorrar)*/
              ]),
        ));
  }
}
