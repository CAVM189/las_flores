import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarHabitacion extends StatefulWidget {
  @override
  _actualizarHabitacionState createState() => _actualizarHabitacionState();
}

class _actualizarHabitacionState extends State<actualizarHabitacion> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController precioController = TextEditingController();
  TextEditingController numeroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Habitacion";
    int operacion = Crear;
    habitacion? una_habitacion;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      operacion = Actualizar;
      una_habitacion = ModalRoute.of(context)?.settings.arguments as habitacion;
      precioController.text = una_habitacion.precio;
      numeroController.text = una_habitacion.numero;
      textWidget = "Actualizar!";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(textWidget),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: numeroController,
                    decoration: InputDecoration(labelText: "Numero"),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: precioController,
                    decoration: InputDecoration(labelText: "Precio"),
                  )),
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text(textWidget),
                    onPressed: () {
                      if (operacion == Actualizar) {
                        _actualizarHabitacion(una_habitacion!);
                      } else {
                        _insertarHabitacion();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _insertarHabitacion() async {
    final una_habitacion = habitacion(
        id_habitacion: M.ObjectId(),
        numero: numeroController.text,
        precio: precioController.text);
    await mdb.insertarHabitacion(una_habitacion);
  }

  _actualizarHabitacion(habitacion una_habitacion) async {
    final una_hab = habitacion(
      id_habitacion: una_habitacion.id_habitacion,
      numero: numeroController.text,
      precio: precioController.text,
    );
    await mdb.actualizarHabitacion(una_hab);
  }

  @override
  void dispose() {
    super.dispose();
    numeroController.dispose();
    precioController.dispose();
  }
}
