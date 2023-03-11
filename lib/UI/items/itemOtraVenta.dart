// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemOtraVenta extends StatelessWidget {
  itemOtraVenta(
      {required this.una_venta,
      required this.tapBorrar,
      required this.tapActualizar});

  final otraventa una_venta;
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
                  flex: 1,
                  child: Text(una_venta.cantidad,
                      style: Theme.of(context).textTheme.headline6)),
              Expanded(
                flex: 6,
                child: Text(" " + una_venta.producto,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                  flex: 2,
                  child: Text(" \$" + una_venta.precio,
                      style: Theme.of(context).textTheme.headline6)),
              Expanded(
                  flex: 4,
                  child: Text(" \$ " + una_venta.total,
                      style: Theme.of(context).textTheme.headline6)),
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /*GestureDetector(child: Icon(Icons.edit), onTap: tapActualizar),*/
                        GestureDetector(
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onTap: tapBorrar)
                      ]))
            ])
            //title: Text('${un_dia.Total}'),
            //subtitle: Text(un_dia.Ruta),

            ));
  }
}
