// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

// ignore: camel_case_types
class item_Empleado extends StatelessWidget {
  item_Empleado(
      {required this.un_empleado,
      required this.tapBorrar,
      required this.tapActualizar});

  final empleado un_empleado;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    String nombre;
    var c = un_empleado.nombre.characters;
    if (c.length >= 15) {
      nombre = c.take(15).toString() + "...";
    } else {
      nombre = un_empleado.nombre;
    }
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Text(
                    nombre,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    un_empleado.DUI.characters.take(7).toString() + "... ",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            child: Icon(Icons.edit), onTap: tapActualizar),
                        /*GestureDetector(child: Icon(Icons.delete), onTap: tapBorrar)*/
                      ]),
                )
              ],
            )));
  }
}
