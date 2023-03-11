// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemInvantario extends StatelessWidget {
  itemInvantario(
      {required this.un_producto,
      required this.tapBorrar,
      required this.tapActualizar});

  final inventario un_producto;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    String producto;
    var c = un_producto.nombre_producto.characters;
    if (c.length >= 16) {
      producto = c.take(16).toString() + "...";
    } else {
      producto = un_producto.nombre_producto;
    }
    var v =
        double.parse(un_producto.cantidad) * double.parse(un_producto.precio);
    return Material(
      elevation: 2.0,
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Text(
                  double.parse(un_producto.cantidad).toStringAsFixed(0),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
            Expanded(
                flex: 6,
                child: Text(
                  producto,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
            Expanded(
                flex: 2,
                child: Text(
                  un_producto.precio,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
            Expanded(
                flex: 2,
                child: Text(
                  v.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
          ])),

      //subtitle: Text(un_dia.Ruta),
    );
  }
}
