// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemHabitacion extends StatelessWidget {
  itemHabitacion(
      {required this.una_habitacion,
      required this.tapBorrar,
      required this.tapActualizar});

  final habitacion una_habitacion;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: Text(
            "#" +
                una_habitacion.numero +
                " - Precio: \$" +
                una_habitacion.precio,
            style: Theme.of(context).textTheme.headline6,
          ),
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
