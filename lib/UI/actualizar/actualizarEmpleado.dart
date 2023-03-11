import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarEmpleado extends StatefulWidget {
  @override
  _actualizarEmpleadoState createState() => _actualizarEmpleadoState();
}

class _actualizarEmpleadoState extends State<actualizarEmpleado> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController nombreController = TextEditingController();
  TextEditingController DUIController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Empleado";
    int operacion = Crear;
    empleado? un_empleado;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      operacion = Actualizar;
      un_empleado = ModalRoute.of(context)?.settings.arguments as empleado;
      nombreController.text = un_empleado.nombre;
      DUIController.text = un_empleado.DUI;
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
                    controller: nombreController,
                    decoration: InputDecoration(labelText: "Nombre"),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: DUIController,
                    decoration: InputDecoration(labelText: "DUI"),
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
                        _actualizarEmpleado(un_empleado!);
                      } else {
                        _insertarEmpleado();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _insertarEmpleado() async {
    final un_empleado = empleado(
        id_empleado: M.ObjectId(),
        nombre: nombreController.text,
        DUI: DUIController.text);
    await mdb.insertarEmpleado(un_empleado);
  }

  _actualizarEmpleado(empleado un_empleado) async {
    final un_emple = empleado(
      id_empleado: un_empleado.id_empleado,
      nombre: nombreController.text,
      DUI: DUIController.text,
    );
    await mdb.actualizarEmpleado(un_emple);
  }

  @override
  void dispose() {
    super.dispose();
    nombreController.dispose();
    DUIController.dispose();
  }
}
