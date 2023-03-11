// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemProducto extends StatelessWidget {
  itemProducto(
      {required this.un_producto,
      required this.tapBorrar,
      required this.tapActualizar});

  final producto un_producto;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(children: [
              Row(children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      un_producto.existencia,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Expanded(
                    flex: 8,
                    child: Text(
                      "  " + un_producto.nombre + "  ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      un_producto.precio_venta,
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      un_producto.valor,
                      style: Theme.of(context).textTheme.headline6,
                    )),
              ])
            ])));
  }
}
