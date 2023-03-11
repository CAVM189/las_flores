import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:flutter/cupertino.dart';

import '../otros/txtNumbersOnly.dart';

class actualizarRemesaBTC extends StatefulWidget {
  @override
  _actualizarRemesaBTCState createState() => _actualizarRemesaBTCState();
}

class _actualizarRemesaBTCState extends State<actualizarRemesaBTC> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController fechaController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController entregoController = TextEditingController();
  TextEditingController recibioController = TextEditingController();
  String? dropdownValue_entrego;

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Remesa";
    int operacion = Crear;
    remesaBTC? un_remesa;
    String? un_dia;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        un_remesa = ModalRoute.of(context)?.settings.arguments as remesaBTC;
        operacion = Actualizar;
        fechaController.text = un_remesa.fecha_dia;
        cantidadController.text = un_remesa.cantidad;
        entregoController.text = un_remesa.entrego;
        recibioController.text = un_remesa.recibio;
        textWidget = "Actualizar!";
      } catch (e) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          un_dia = ModalRoute.of(context)?.settings.arguments as String;
          fechaController.text = un_dia;
          textWidget = "Añadir remesa en BTC del " + un_dia;
          //horaController.text = '${_time_ini.format(context)}';
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(textWidget),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: txtNumbersOnly(
                      tapCalcular: () {
                        //_calcularValores();
                      },
                      cantidadController: cantidadController,
                      disponibilidadController: new TextEditingController())),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text(
                              "Entregó:",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getEmpleados(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      width: 1000,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(dropdownValue_entrego ??
                                            'Seleccionar Empleado'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_entrego = value;
                                            entregoController.text =
                                                dropdownValue_entrego!;
                                          });
                                        },
                                        value: dropdownValue_entrego,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var emp = empleado.fromMap(item);
                                          String nombre;
                                          var c = emp.nombre.characters;
                                          if (c.length >= 20) {
                                            nombre =
                                                c.take(20).toString() + "...";
                                          } else {
                                            nombre = emp.nombre;
                                          }
                                          return DropdownMenuItem<String>(
                                            value: emp.nombre,
                                            child: Text(nombre!),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container(
                                      child: Center(
                                        child: Text('Cargando...'),
                                      ),
                                    );
                            },
                          )))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: recibioController,
                    decoration: InputDecoration(labelText: "Recibió:"),
                  )),
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text("Guardar"),
                    onPressed: () {
                      if (operacion == Actualizar) {
                        _actualizarRemesaBTC(un_remesa!);
                      } else {
                        _insertarRemesaBTC();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _insertarRemesaBTC() async {
    final un_remesa = remesaBTC(
        id_remesa: M.ObjectId(),
        fecha_dia: fechaController.text,
        cantidad: cantidadController.text,
        entrego: entregoController.text,
        recibio: recibioController.text);
    await mdb.insertarRemesaBTC(un_remesa);
  }

  _actualizarRemesaBTC(remesaBTC un_remesa) async {
    final un_rem = remesaBTC(
        id_remesa: un_remesa.id_remesa,
        fecha_dia: fechaController.text,
        cantidad: cantidadController.text,
        entrego: entregoController.text,
        recibio: recibioController.text);
    await mdb.actualizarRemesaBTC(un_rem);
  }

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
    cantidadController.dispose();
    entregoController.dispose();
    recibioController.dispose();
  }
}
