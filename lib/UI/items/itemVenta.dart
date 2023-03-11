// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemVenta extends StatelessWidget {
  itemVenta(
      {required this.una_venta,
      required this.tapBorrar,
      required this.tapActualizar});

  final venta una_venta;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    String producto;
    var c = una_venta.producto.characters;
    if (c.length >= 15) {
      producto = c.take(15).toString() + "...";
    } else {
      producto = una_venta.producto;
    }
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: GestureDetector(
            child: Text(
                una_venta.cantidad + " " + producto + "  \$" + una_venta.total,
                style: Theme.of(context).textTheme.headline6),
          ),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*GestureDetector(child: Icon(Icons.edit), onTap: tapActualizar),*/
                GestureDetector(child: Icon(Icons.delete), onTap: tapBorrar)
              ]),
        ));
  }
}
