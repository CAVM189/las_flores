import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:flutter/cupertino.dart';

class actualizarBase extends StatefulWidget {
  @override
  _actualizarBaseState createState() => _actualizarBaseState();
}

String? dropdownValue_entrego;
String? dropdownValue_recibio;

class _actualizarBaseState extends State<actualizarBase> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController fechaController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController entregoController = TextEditingController();
  TextEditingController recibioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Base";
    int operacion = Crear;
    base? una_base;
    String? un_dia;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        una_base = ModalRoute.of(context)?.settings.arguments as base;
        fechaController.text = una_base.fecha_dia;
        cantidadController.text = una_base.cantidad;
        if (dropdownValue_entrego == null) {
          dropdownValue_entrego = una_base.entrego;
        }
        if (dropdownValue_recibio == null) {
          dropdownValue_recibio = una_base.recibio;
        }
        operacion = Actualizar;
        textWidget = "Actualizar!";
      } catch (e) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          un_dia = ModalRoute.of(context)?.settings.arguments as String;
          fechaController.text = un_dia;
          textWidget = "Base del " + un_dia;
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cantidadController,
                    decoration: InputDecoration(labelText: "Cantidad (\$)"),
                  )),
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
                      flex: 5,
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
                                          });
                                        },
                                        value: dropdownValue_entrego,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var emp = empleado.fromMap(item);

                                          String nombre;
                                          var c = emp.nombre.characters;
                                          if (c.length >= 25) {
                                            nombre =
                                                c.take(25).toString() + "...";
                                          } else {
                                            nombre = emp.nombre;
                                          }
                                          return DropdownMenuItem<String>(
                                            value: emp.nombre,
                                            child: Text(nombre),
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
                              "Recibió:",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 5,
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
                                        hint: Text(dropdownValue_recibio ??
                                            'Seleccionar Empleado'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_recibio = value;
                                          });
                                        },
                                        value: dropdownValue_recibio,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var emp = empleado.fromMap(item);
                                          String nombre;
                                          var c = emp.nombre.characters;
                                          if (c.length >= 25) {
                                            nombre =
                                                c.take(25).toString() + "...";
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
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text("Guardar"),
                    onPressed: () async {
                      if (operacion == Actualizar) {
                        _actualizarBase(una_base!);
                      } else {
                        _insertarBase();
                        setState(() {});
                        Navigator.pop(context);
                      }
                    }),
              ))
        ]));
  }

  _insertarBase() async {
    final un_base = base(
        id_base: M.ObjectId(),
        fecha_dia: fechaController.text,
        cantidad: cantidadController.text,
        entrego: dropdownValue_entrego!,
        recibio: dropdownValue_recibio!);
    await mdb.actualizarEfDia(un_base.fecha_dia, un_base.cantidad);
    await mdb.insertarBase(un_base);
    //mdb
  }

  _actualizarBase(base un_base) async {
    final un_bas = base(
        id_base: un_base.id_base,
        fecha_dia: fechaController.text,
        cantidad: cantidadController.text,
        entrego: dropdownValue_entrego!,
        recibio: dropdownValue_recibio!);
    await mdb.actualizarBase(un_bas);
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
