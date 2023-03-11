// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemCompra extends StatelessWidget {
  itemCompra(
      {required this.una_compra,
      required this.numero,
      required this.tapBorrar,
      required this.tapActualizar});

  final compra una_compra;
  final String numero;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(children: [
              Expanded(
                flex: 8,
                child: Text(
                    numero +
                        ")  " +
                        una_compra.cantidad +
                        "  " +
                        una_compra.producto,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                  flex: 3,
                  child: Text("\$" + una_compra.total,
                      style: Theme.of(context).textTheme.headline6)),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onTap: tapBorrar)),
            ])));
  }
}
