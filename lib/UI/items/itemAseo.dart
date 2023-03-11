// ignore: file_names
import 'package:flutter/material.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemAseo extends StatelessWidget {
  itemAseo(
      {required this.numero,
      required this.un_aseo,
      required this.tapBorrar,
      required this.tapActualizar});

  final String numero;
  final aseo un_aseo;
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
                        un_aseo.inicio +
                        "  -  Hab#" +
                        un_aseo.habitacion,
                    style: Theme.of(context).textTheme.headline6),
              ),
              //title: Text('${un_dia.Total}'),
              //subtitle: Text(un_dia.Ruta),
              Expanded(
                flex: 1,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            child: Icon(Icons.edit), onTap: tapActualizar),
                      ),
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
