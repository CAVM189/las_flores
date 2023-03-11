// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemBase extends StatelessWidget {
  itemBase(
      {required this.una_base,
      required this.tapBorrar,
      required this.tapActualizar});

  final base una_base;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: GestureDetector(
            child: Text(una_base.recibio + " recibió \$" + una_base.cantidad,
                style: Theme.of(context).textTheme.headline6),
          ),
          //title: Text('${un_dia.Total}'),
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
