// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:las_flores/modelos/modelos.dart';

class itemServicio extends StatelessWidget {
  itemServicio(
      {required this.un_servicio,
      required this.numero,
      required this.tapBorrar,
      required this.tapActualizar});

  final servicio un_servicio;
  final String numero;
  final VoidCallback tapBorrar, tapActualizar;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2.0,
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(children: [
              Expanded(
                flex: 7,
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        numero + ") ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.access_time,
                        size: 20,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        un_servicio.entrada,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.meeting_room,
                        size: 20,
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        un_servicio.habitacion,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ))
                ]),
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    un_servicio.transporte,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                      color: HexColor(un_servicio.color_carro),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                          child: Text("")))),
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
                      /* Expanded(
                        child: GestureDetector(
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onTap: tapBorrar),
                      )*/
                    ]),
              )
            ])));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
