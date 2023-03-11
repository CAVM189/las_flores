import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:las_flores/UI/actualizar/actualizarCortesia.dart';
import 'package:las_flores/UI/actualizar/actualizarVenta.dart';
import 'package:las_flores/UI/actualizar/actualizarTransporte.dart';
import 'package:las_flores/UI/items/itemCortesia.dart';
import 'package:las_flores/UI/items/itemVenta.dart';
import 'package:las_flores/UI/otros/transportes.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarServicio extends StatefulWidget {
  @override
  _actualizarServicioState createState() => _actualizarServicioState();
}

class _actualizarServicioState extends State<actualizarServicio> {
  static const Actualizar = 1;
  static const Crear = 0;

  Color? mycolor;
//controladores
  TextEditingController fecha_diaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController entradaController = TextEditingController();
  TextEditingController habitacionController = TextEditingController();
  TextEditingController salidaController = TextEditingController();
  TextEditingController duracionController = TextEditingController();
  TextEditingController empleadoController = TextEditingController();
  TextEditingController efectivoController = TextEditingController();
  TextEditingController btcController = TextEditingController();
  TextEditingController placa_carroController = TextEditingController();
  TextEditingController transporteController = TextEditingController();
  TextEditingController color_carroController = TextEditingController();
  TextEditingController taxiController = TextEditingController();
  TextEditingController notaController = TextEditingController();
  TextEditingController ingreso = TextEditingController();
  TextEditingController? controller;

//FinControladores
  bool _isChecked = false;
  bool _isChecked1 = false;
  bool val = false;
  String _currText = '';
  TimeOfDay _time_ini =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  TimeOfDay _time_end = TimeOfDay.now().plusMinutes(15);
  String? dropdownValue_habitacion;
  String? dropdownValue_empleado;
  String? dropdownValue_transporte;
  var nuevoID = M.ObjectId();
  List<venta> ventas_servicio = [];
  List<cortesia> cortesias_servicio = [];

  String? value;
  String label = "";
  Function? onChanged;
  String? error;
  Widget? icon;
  bool allowDecimal = true;

  @override
  Widget build(BuildContext context) {
    ingreso.text = "0";
    var textWidget = "";
    int operacion = Crear;
    servicio? un_servicio;
    dia? un_dia;
    List<habitacion> lista_habitaciones = [];

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        un_servicio = ModalRoute.of(context)?.settings.arguments as servicio;
        operacion = Actualizar;
        nuevoID = un_servicio.id_servicio;

        fecha_diaController.text = un_servicio.fecha_dia;
        entradaController.text = un_servicio.entrada;
        habitacionController.text = un_servicio.habitacion;
        dropdownValue_habitacion = un_servicio.habitacion;
        salidaController.text = un_servicio.salida;
        duracionController.text = un_servicio.duracion;
        empleadoController.text = un_servicio.empleado;
        dropdownValue_empleado = un_servicio.empleado;
        efectivoController.text = un_servicio.efectivo;
        btcController.text = un_servicio.btc;
        placa_carroController.text = un_servicio.placa_carro;
        transporteController.text = un_servicio.transporte;
        dropdownValue_transporte = un_servicio.transporte;

        if (mycolor == null) {
          mycolor = HexColor(un_servicio.color_carro);
          color_carroController.text = '#${mycolor!.value.toRadixString(16)}';
        }

        taxiController.text = un_servicio.taxi_carro.toString();
        notaController.text = un_servicio.nota;
        textWidget = "Servicio del " +
            un_servicio.fecha_dia +
            " |Hora:" +
            un_servicio.entrada;
      } catch (e) {
        List<Object?> a =
            ModalRoute.of(context)?.settings.arguments! as List<Object?>;
        var c = (a[1] as int);
        var f = (a[0] as String);
        textWidget = "Servicio #" + (c + 1).toString() + " - " + f;
        fecha_diaController.text = f;
        numeroController.text = (c + 1).toString();
        taxiController.text = (_isChecked).toString();

        if (mycolor == null) {
          mycolor = Colors.black;
          //mycolor = HexColor(un_servicio.color_carro);
          color_carroController.text = '#${mycolor!.value.toRadixString(16)}';
        }

        color_carroController.text = '#${mycolor!.value.toRadixString(16)}';
        entradaController.text = '${_time_ini.format(context)}';
        salidaController.text = '${_time_end.format(context)}';
        duracionController.text = '${_duration(_time_ini, _time_end)}';
      }
    }

    //var l = getEmpleadosList();

    return Scaffold(
        appBar: AppBar(title: Text(textWidget), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _eliminarServicio(un_servicio!);
                },
                child: Icon(
                  Icons.delete_forever,
                  size: 40.0,
                ),
              )),
        ]),
        body: Stack(children: [
          SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                              child: TextField(
                                                  controller: entradaController,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      labelText: "Entrada"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 30, 0, 0),
                                              child: ElevatedButton(
                                                  child: Icon(
                                                    Icons.directions_walk,
                                                    size: 30.0,
                                                  ), //Text('Cambiar'),
                                                  onPressed:
                                                      _selectTimeEntrada),
                                            )),
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: TextField(
                                                    controller:
                                                        salidaController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                        labelText: "Salida"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6))),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 30, 0, 0),
                                                child: ElevatedButton(
                                                    child: Transform(
                                                        alignment:
                                                            Alignment.center,
                                                        transform:
                                                            Matrix4.rotationY(
                                                                3),
                                                        child: Icon(
                                                          Icons.directions_walk,
                                                          size: 30.0,
                                                        )), //Text('Cambiar'),
                                                    onPressed:
                                                        _selectTimeSalida)))
                                      ])
                                ])),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                            child: TextField(
                                controller: duracionController,
                                textAlign: TextAlign.center,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: "Duración:",
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center),
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        ),
                      ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text(
                              "Habitación:",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 5,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getHabitaciones(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(dropdownValue_habitacion ??
                                            'Seleccionar Numero'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_habitacion = value;
                                            habitacionController.text =
                                                dropdownValue_habitacion!;
                                            var pre = lista_habitaciones
                                                .where((element) =>
                                                    dropdownValue_habitacion!
                                                        .contains(
                                                            element.numero) ==
                                                    true)
                                                .first;
                                            efectivoController.text =
                                                pre.precio;
                                          });
                                        },
                                        value: dropdownValue_habitacion,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var hab = habitacion.fromMap(item);
                                          lista_habitaciones.add(hab);

                                          return DropdownMenuItem<String>(
                                            value: hab.numero,
                                            child: Text("#" +
                                                hab.numero! +
                                                "   -   Precio:\$" +
                                                hab.precio),
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
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text(
                              "Atención:",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getEmpleados(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(dropdownValue_empleado ??
                                            'Seleccionar Empleado'),
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
                  padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                  child: Text("Cortesias:",
                      style: Theme.of(context).textTheme.headline6)),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: FutureBuilder(
                    future: mdb.getCortesiasServicio(nuevoID),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            color: Colors.white,
                            child: const LinearProgressIndicator(
                                backgroundColor: Colors.black));
                      } else if (snapshot.hasError) {
                        return Container(
                            color: Colors.white,
                            child: Center(
                                child: Text("Error de conexión",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6)));
                      } else {
                        var s =
                            double.parse(snapshot.data.length.toString()) * 60;
                        numeroController.text = snapshot.data.length.toString();

                        return Row(children: <Widget>[
                          Expanded(
                              child: SizedBox(
                                  height: s,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      cortesias_servicio.add(cortesia
                                          .fromMap(snapshot.data[index]));
                                      return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: itemCortesia(
                                              una_cortesia: cortesia.fromMap(
                                                  snapshot.data[index]),
                                              tapBorrar: () async {
                                                _eliminarCortesia(
                                                    cortesia.fromMap(
                                                        snapshot.data[index]));
                                              },
                                              tapActualizar: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                            context) {
                                                          return actualizarCortesia();
                                                        },
                                                        settings: RouteSettings(
                                                          arguments: cortesia
                                                              .fromMap(snapshot
                                                                  .data[index]),
                                                        ))).then(
                                                    (value) => setState(() {
                                                          value = value;
                                                        }));
                                              }));
                                    },
                                    itemCount: snapshot.data.length,
                                  )))
                        ]);
                      }
                    },
                  )),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return actualizarCortesia();
                          },
                          settings: RouteSettings(arguments: [
                            nuevoID,
                            fecha_diaController.text,
                            numeroController.text
                          ]))).then((value) => setState(() {}));
                },
                child: Text("Añadir +"),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: FutureBuilder(
                    future: mdb.getVentasDia(nuevoID),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            color: Colors.white,
                            child: const LinearProgressIndicator(
                                backgroundColor: Colors.black));
                      } else if (snapshot.hasError) {
                        return Container(
                            color: Colors.white,
                            child: Center(
                                child: Text("Error de conexión",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6)));
                      } else {
                        var l = double.parse(snapshot.data.length.toString());
                        var s = l * 60;

                        numeroController.text = snapshot.data.length.toString();

                        for (int i = 0; i < l; i++) {
                          ingreso.text = (double.parse(ingreso.text) +
                                  double.parse(
                                      venta.fromMap(snapshot.data[i]).total))
                              .toString();
                        }

                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                            child: Text("Ventas: " + " \$" + ingreso.text,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          Row(children: <Widget>[
                            Expanded(
                                child: SizedBox(
                                    height: s,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        ventas_servicio.add(venta
                                            .fromMap(snapshot.data[index]));
                                        return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: itemVenta(
                                                una_venta: venta.fromMap(
                                                    snapshot.data[index]),
                                                tapBorrar: () async {
                                                  _eliminarVenta(venta.fromMap(
                                                      snapshot.data[index]));
                                                },
                                                tapActualizar: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return actualizarVenta();
                                                          },
                                                          settings:
                                                              RouteSettings(
                                                            arguments: venta
                                                                .fromMap(snapshot
                                                                        .data[
                                                                    index]),
                                                          ))).then(
                                                      (value) => setState(() {
                                                            value = value;
                                                          }));
                                                }));
                                      },
                                      itemCount: snapshot.data.length,
                                    ))),
                          ])
                        ]);
                      }
                    },
                  )),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return actualizarVenta();
                          },
                          settings: RouteSettings(arguments: [
                            nuevoID,
                            fecha_diaController.text,
                            numeroController.text
                          ]))).then((value) => setState(() {}));
                },
                child: Text("Añadir +"),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                            child: Text("Pago",
                                style: Theme.of(context).textTheme.headline6)))
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: efectivoController,
                        readOnly: true,
                        style: Theme.of(context).textTheme.headline6,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: allowDecimal),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(_getRegexString())),
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                              text: newValue.text.replaceAll('.', ','),
                            ),
                          ),
                        ],
                        decoration: InputDecoration(
                          label: Text("Efectivo"),
                          errorText: error,
                          icon: icon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: btcController,
                        readOnly: true,
                        style: Theme.of(context).textTheme.headline6,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: allowDecimal),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(_getRegexString())),
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                              text: newValue.text.replaceAll('.', ','),
                            ),
                          ),
                        ],
                        decoration: InputDecoration(
                          label: Text("BTC"),
                          errorText: error,
                          icon: icon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: CheckboxListTile(
                              title: Text(
                                "?",
                                textAlign: TextAlign.right,
                              ),
                              value: _isChecked1,
                              onChanged: (val) {
                                setState(() {
                                  _isChecked1 = val!;
                                  if (val == true) {
                                    btcController.text =
                                        efectivoController.text;
                                    efectivoController.text = "";
                                  } else {
                                    efectivoController.text =
                                        btcController.text;
                                    btcController.text = "";
                                  }
                                });
                              }))),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                            child: Text("Vehiculo",
                                style: Theme.of(context).textTheme.headline6))),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: FutureBuilder(
                            future: mdb.getTransporte(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      width: 1000,
                                      child: DropdownButton<String>(
                                        hint: Text(dropdownValue_transporte ??
                                            'Seleccione tipo'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_transporte = value;
                                            transporteController.text =
                                                dropdownValue_transporte!;
                                          });
                                        },
                                        value: dropdownValue_transporte,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var emp = transporte.fromMap(item);
                                          return DropdownMenuItem<String>(
                                            value: emp.tipo,
                                            child: Text(emp.tipo,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
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
                          ))),
                  Expanded(
                      flex: 2,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: ElevatedButton(
                              child: const Text('+'),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return actualizarTransporte();
                                })).then((value) => setState(() {}));
                              }))),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mycolor),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Selecione color!'),
                                    content: SingleChildScrollView(
                                      child: BlockPicker(
                                          pickerColor: mycolor!, //default color
                                          onColorChanged: changeColor),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Listo'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); //dismiss the color picker
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text("Color"),
                        ),
                      ))
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextField(
                              controller: placa_carroController,
                              decoration: InputDecoration(labelText: "Placa?"),
                              style: Theme.of(context).textTheme.headline6),
                        )),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: CheckboxListTile(
                              title: Text(
                                "Es taxi?",
                                textAlign: TextAlign.right,
                              ),
                              value: _isChecked,
                              onChanged: (val) {
                                setState(() {
                                  _isChecked = val!;
                                  if (val == true) {
                                    taxiController.text = "true";
                                  } else {
                                    taxiController.text = "false";
                                  }
                                });
                              }),
                        ))
                  ]),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 200),
                  child: TextField(
                    controller: notaController,
                    decoration: InputDecoration(labelText: "Observaciones"),
                    style: Theme.of(context).textTheme.headline6,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 6, // when user presses enter it will adapt to it
                  ))
/**/
              /*---------------------------------*/
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text('Guardar'),
                    onPressed: () async {
                      if (operacion == Actualizar) {
                        if (await _actualizarServicio(un_servicio!) == true) {
                          Navigator.pop(context);
                        }
                      } else {
                        if (await _insertarServicio() == true) {
                          Navigator.pop(context);
                        }
                      }
                    }),
              ))
        ]));
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';

  _eliminarServicio(servicio un_servicio) {
    showAlertDialogS(context, un_servicio);
  }

  showAlertDialogS(BuildContext context, servicio un_servicio) {
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)))),
      child: Container(
          color: Colors.red,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Eliminar!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)))),
      onPressed: () async {
        var c = cortesias_servicio.toSet().toList();
        for (int i = 0; i < c.length; i++) {
          await mdb.actualizarExProducto(c[i].producto, c[i].cantidad);
        }
        var v = ventas_servicio.toSet().toList();
        for (int i = 0; i < v.length; i++) {
          await mdb.actualizarExProducto(v[i].producto, v[i].cantidad);
        }

        await mdb.borrarVentas(un_servicio.id_servicio.toString());
        await mdb.borrarCortesias(un_servicio.id_servicio.toString());
        var cant = (double.parse(ingreso.text) +
            double.parse(efectivoController.text));
        await mdb.restarEfDia(un_servicio.fecha_dia, cant.toString());
        await mdb.borrarServicio(un_servicio);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Container(
          height: 200,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                child: Text("Desea eliminar el servicio Hora:" +
                    un_servicio.entrada +
                    " Habitacion:" +
                    un_servicio.habitacion.toString() +
                    " junto con toda su actividad permanentemente?")),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                child: Text("Elimine las cortesias existentes")),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: Container(
                    color: HexColor(un_servicio.color_carro),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text("Transporte: " + un_servicio.transporte,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800))))),
          ])),
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

  _eliminarCortesia(cortesia una_cortesia) async {
    showAlertDialogC(context, una_cortesia);
  }

  showAlertDialogC(BuildContext context, cortesia una_cortesia) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.actualizarExProducto(
            una_cortesia.producto, una_cortesia.cantidad);
        await mdb.borrarCortesia(una_cortesia);
        Navigator.of(context).pop(true);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la cortesia de " +
          una_cortesia.cantidad +
          " " +
          una_cortesia.producto +
          "?"),
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

  _eliminarVenta(venta una_venta) async {
    showAlertDialogV(context, una_venta);
  }

  showAlertDialogV(BuildContext context, venta una_venta) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.actualizarExProducto(una_venta.producto, una_venta.cantidad);
        await mdb.restarEfDia(una_venta.fecha_venta, una_venta.total);
        await mdb.borrarVenta(una_venta);

        Navigator.of(context).pop(true);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la venta de " +
          una_venta.cantidad +
          " " +
          una_venta.producto +
          "?"),
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

// ValueChanged<Color> callback
  void changeColor(Color color) {
    color_carroController.text =
        '#${color.value.toRadixString(16)}'; //color.toString();
    setState(() => mycolor = color);
  }

  _insertarServicio() async {
    if (habitacionController.text == "" ||
        empleadoController.text == "" ||
        placa_carroController.text == "" ||
        transporteController.text == "" ||
        (efectivoController.text == "" && btcController.text == "")) {
      showAlertDialog(context);
    } else {
      final un_servicio = servicio(
        id_servicio: nuevoID,
        fecha_dia: fecha_diaController.text,
        entrada: entradaController.text,
        habitacion: habitacionController.text,
        salida: salidaController.text,
        duracion: duracionController.text,
        empleado: empleadoController.text,
        efectivo: efectivoController.text,
        btc: btcController.text,
        placa_carro: placa_carroController.text,
        transporte: transporteController.text,
        color_carro: color_carroController.text,
        taxi_carro: bool.fromEnvironment(taxiController.text),
        nota: notaController.text,
      );
      await mdb.actualizarEfDia(un_servicio.fecha_dia, efectivoController.text);
      await mdb.insertarServicio(un_servicio);
      return true;
    }
  }

  _actualizarServicio(servicio un_servicio) async {
    final un_serv = servicio(
      id_servicio: un_servicio.id_servicio,
      fecha_dia: fecha_diaController.text,
      entrada: entradaController.text,
      habitacion: habitacionController.text,
      salida: salidaController.text,
      duracion: duracionController.text,
      empleado: empleadoController.text,
      efectivo: efectivoController.text,
      btc: btcController.text,
      placa_carro: placa_carroController.text,
      transporte: transporteController.text,
      color_carro: color_carroController.text,
      taxi_carro: bool.fromEnvironment(taxiController.text),
      nota: notaController.text,
    );
    await mdb.restarEfDia(un_servicio.fecha_dia, un_servicio.efectivo);
    await mdb.actualizarEfDia(un_servicio.fecha_dia, efectivoController.text);

    await mdb.actualizarServicio(un_serv);
    return true;
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Cerrar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Complete los datos necesarios!"),
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

  _selectTimeEntrada() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time_ini,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null) {
      setState(() {
        _time_ini = newTime;
        _time_end = newTime.plusMinutes(15);
        entradaController.text = '${newTime.format(context)}';
        salidaController.text = '${newTime.format(context)}';
        duracionController.text = '${_duration(_time_ini, _time_end)}';
      });
    }
  }

  _selectTimeSalida() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time_end,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null) {
      setState(() {
        _time_end = newTime;
        salidaController.text = '${newTime.format(context)}';
        duracionController.text = '${_duration(_time_ini, _time_end)}';
      });
    }
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

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay plusMinutes(int minutes) {
    if (minutes == 0) {
      return this;
    } else {
      int mofd = this.hour * 60 + this.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return this;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }
}

_duration(TimeOfDay start_time, TimeOfDay end_time) {
  var format = DateFormat("HH:mm");
  var start = format
      .parse(start_time.hour.toString() + ":" + start_time.minute.toString());
  var end =
      format.parse(end_time.hour.toString() + ":" + end_time.minute.toString());
  int hours = 0;
  int minutes = 0;
  if (start.isAfter(end)) {
    end = end.add(Duration(days: 1));
  }
  Duration diff = end.difference(start);
  hours = diff.inHours;
  minutes = diff.inMinutes % 60;

  return hours.toString() + ":" + minutes.toString();
}
