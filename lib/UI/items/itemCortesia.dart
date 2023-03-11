// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemCortesia extends StatelessWidget {
  itemCortesia(
      {required this.una_cortesia,
      required this.tapBorrar,
      required this.tapActualizar});

  final cortesia una_cortesia;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: GestureDetector(
            child: Text(una_cortesia.cantidad + " " + una_cortesia.producto,
                style: Theme.of(context).textTheme.headline6),
          ),
          //title: Text('${un_dia.Total}'),
          //subtitle: Text(un_dia.Ruta),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*GestureDetector(child: Icon(Icons.edit), onTap: tapActualizar),*/
                GestureDetector(child: Icon(Icons.delete), onTap: tapBorrar)
              ]),
        ));
  }
}
