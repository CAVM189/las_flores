import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:path_provider/path_provider.dart';
import '../otros/txtNumbersOnly.dart';
import 'Camara/TakePictureScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:ui' as ui;

class actualizarGasto extends StatefulWidget {
  //const loadPicturePage({Key? key}) : super(key: key);
  @override
  _actualizarGastoState createState() => _actualizarGastoState();
}

// Obtén una cámara específica de la lista de cámaras disponibles
const Actualizar = 1;
const Crear = 0;

class _actualizarGastoState extends State<actualizarGasto> {
  TextEditingController fechaController = TextEditingController();
  TextEditingController empleadoController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  int el = 0;
  TimeOfDay _time_ini =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

  String? dropdownValue_empleado;
  File? _imagefileNuevo;
  Image? im;
  @override
  Widget build(BuildContext context) {
    var textWidget = "Nuevo";
    int operacion = Crear;
    String? un_dia;
    gasto? un_gasto;

    //firstCamera = camera.first;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        un_gasto = ModalRoute.of(context)?.settings.arguments as gasto;
        operacion = Actualizar;
        fechaController.text = un_gasto.fecha_dia;
        empleadoController.text = un_gasto.empleado;
        dropdownValue_empleado = un_gasto.empleado;
        tipoController.text = un_gasto.tipo;
        cantidadController.text = un_gasto.cantidad;
        horaController.text = un_gasto.hora;

        /* File file = File('profile.png');
        file.writeAsBytes(imBytes.buffer
            .asUint8List(imBytes.offsetInBytes, imBytes.lengthInBytes));*/
        if (el == 0) {
          try {
            var imBytes = Utility.imageFromBase64String(un_gasto.comprobante);
            im = imBytes;
          } catch (e) {
            im = null;
          }
        }
        textWidget = "Actualizar!";
      } catch (e) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          un_dia = ModalRoute.of(context)?.settings.arguments as String;
          fechaController.text = un_dia;
          textWidget = "Nuevo gasto del " + un_dia;
          horaController.text = '${_time_ini.format(context)}';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Text(
                              "Quien gastó:",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                          child: FutureBuilder(
                            future: mdb.getEmpleados(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      width: 200,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(dropdownValue_empleado ??
                                            'Seleccionar'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_empleado = value;
                                            empleadoController.text =
                                                dropdownValue_empleado!;
                                          });
                                        },
                                        value: dropdownValue_empleado,
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: tipoController,
                    decoration: InputDecoration(labelText: "Descripción"),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: txtNumbersOnly(
                    tapCalcular: () {
                      //calcularValores();
                    },
                    cantidadController: cantidadController,
                    disponibilidadController: new TextEditingController(),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextField(
                              controller: horaController,
                              decoration:
                                  InputDecoration(labelText: "Hora de Gasto"),
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              child: Icon(
                                Icons.schedule,
                                size: 30.0,
                              ),
                              onPressed: _selectTime),
                        ),
                      ])),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: (im != null) ? im! : Text("Anexar comprobante.")),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return CameraWidget();
                                    },
                                  )).then((value) => setState(() {
                                        if (value != null) {
                                          im = null;
                                          _imagefileNuevo =
                                              File(value.toString());
                                          im = Image.file(_imagefileNuevo!);
                                        }
                                      }));
                                },
                                child: const Text('+Foto')),
                          ),
                        ],
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: (() => eliminar()),
                            child: const Text('Eliminar')),
                      ),
                    ))
                  ])
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
                        _actualizarGasto(un_gasto!);
                      } else {
                        _insertarGasto();
                      }
                    }),
              ))
        ]));
  }

  void eliminar() {
    setState(() {
      try {
        im = null;
        _imagefileNuevo = null;
        el = 1;
      } catch (e) {}
    });
  }

  _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time_ini,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null) {
      setState(() {
        _time_ini = newTime;
        horaController.text = '${newTime.format(context)}';
      });
    }
  }

  _actualizarGasto(gasto un_gasto) async {
    String imgString = "";
    try {
      imgString = Utility.base64String(await _imagefileNuevo!.readAsBytes());
    } catch (e) {
      imgString = un_gasto.comprobante;
    }
    final un_bas = gasto(
      id_gasto: un_gasto.id_gasto,
      fecha_dia: fechaController.text,
      empleado: empleadoController.text,
      tipo: tipoController.text,
      cantidad: cantidadController.text,
      hora: horaController.text,
      comprobante: imgString,
    );
    String c = "0";
    var anterior = double.parse(un_bas.cantidad);
    var nueva = double.parse(cantidadController.text);
    if (anterior > nueva) {
      c = (nueva - anterior).toString();
      await mdb.restarEfDia(un_bas.fecha_dia, c);
    }
    if (anterior < nueva) {
      c = (anterior - nueva).toString();
      await mdb.restarEfDia(un_bas.fecha_dia, c);
    }
    await mdb.actualizarGasto(un_bas);
  }

  _insertarGasto() async {
    if (empleadoController.text == "" ||
        tipoController.text == "" ||
        cantidadController.text == "") {
      showAlertDialog(context);
    } else {
      String imgString = "";
      try {
        imgString = Utility.base64String(await _imagefileNuevo!.readAsBytes());
      } catch (e) {}
      final un_gasto = gasto(
        id_gasto: M.ObjectId(),
        fecha_dia: fechaController.text,
        empleado: empleadoController.text,
        tipo: tipoController.text,
        cantidad: cantidadController.text,
        hora: horaController.text,
        comprobante: imgString,
      );
      await mdb.restarEfDia(un_gasto.fecha_dia, un_gasto.cantidad);
      await mdb.insertarGasto(un_gasto);
      Navigator.pop(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Erro"),
      content: Text("Complete todos los datos necesarios"),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
    empleadoController.dispose();
    tipoController.dispose();
    cantidadController.dispose();
    horaController.dispose();
  }
}

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
