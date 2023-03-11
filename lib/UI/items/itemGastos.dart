// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemGastos extends StatelessWidget {
  itemGastos(
      {required this.un_gasto,
      required this.numero,
      required this.tapBorrar,
      required this.tapActualizar});

  final gasto un_gasto;
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
                flex: 4,
                child: Text(
                    numero +
                        ")  Hora: " +
                        un_gasto.hora +
                        "  -  " +
                        un_gasto.tipo,
                    style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                  flex: 1,
                  child: Text("\$" + un_gasto.cantidad,
                      style: Theme.of(context).textTheme.headline6)),
              Expanded(
                flex: 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /*Expanded(
                        child: GestureDetector(
                            child: Icon(Icons.edit), onTap: tapActualizar),
                      ),*/
                      Expanded(
                        child: GestureDetector(
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onTap: tapBorrar),
                      )
                    ]),
              )
            ])));
  }
}
