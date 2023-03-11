import 'package:flutter/material.dart';
import 'package:las_flores/UI/otros/habitaciones.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:intl/intl.dart';

class actualizarAseo extends StatefulWidget {
  @override
  _actualizarAseoState createState() => _actualizarAseoState();
}

class _actualizarAseoState extends State<actualizarAseo> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController fecha_diaController = TextEditingController();
  TextEditingController inicioController = TextEditingController();
  TextEditingController finController = TextEditingController();
  TextEditingController duracionController = TextEditingController();
  TextEditingController habitacionController = TextEditingController();
  TextEditingController empleadoController = TextEditingController();
  TextEditingController notasController = TextEditingController();

  TimeOfDay _time_ini =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
  TimeOfDay _time_end = TimeOfDay.now().plusMinutes(15);
  String? dropdownValue_habitacion;
  String? dropdownValue_empleado;

  @override
  Widget build(BuildContext context) {
    var textWidget = "Nuevo";
    int operacion = Crear;
    aseo? un_aseo;
    String? un_dia;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        un_aseo = ModalRoute.of(context)?.settings.arguments as aseo;

        fecha_diaController.text = un_aseo.fecha_dia;
        inicioController.text = un_aseo.inicio;
        finController.text = un_aseo.fin;
        duracionController.text = un_aseo.duracion;
        habitacionController.text = un_aseo.habitacion;
        empleadoController.text = un_aseo.empleado;
        dropdownValue_empleado = un_aseo.empleado;
        dropdownValue_habitacion = un_aseo.habitacion;
        notasController.text = un_aseo.notas;
        textWidget = "Actualizar aseo del " + un_aseo.fecha_dia;
        operacion = Actualizar;
      } catch (e) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          un_dia = ModalRoute.of(context)?.settings.arguments as String;
          textWidget = "Nuevo aseo del " + un_dia;
          fecha_diaController.text = un_dia;
          inicioController.text = '${_time_ini.format(context)}';
          finController.text = '${_time_end.format(context)}';
          duracionController.text = '${_duration(_time_ini, _time_end)}';
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
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
                                                  controller: inicioController,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      labelText: "Inicio"),
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
                                                  onPressed: _selectTimeInicio),
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
                                                    controller: finController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                        labelText: "Fin"),
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
                                                    onPressed: _selectTimeFin)))
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
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text(
                              "Habitación",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getHabitaciones(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? Container(
                                      width: 1000,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        hint: Text(dropdownValue_habitacion ??
                                            'Seleccionar'),
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownValue_habitacion = value;
                                            habitacionController.text =
                                                dropdownValue_habitacion!;
                                          });
                                        },
                                        value: dropdownValue_habitacion,
                                        items: snapshot.data
                                            .map<DropdownMenuItem<String>>(
                                                (item) {
                                          var emp = habitacion.fromMap(item);
                                          return DropdownMenuItem<String>(
                                            value: emp.numero,
                                            child: Text("Numero: " +
                                                emp.numero +
                                                "  |  Precio:\$" +
                                                emp.precio!),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              "Empleados",
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
                                          return DropdownMenuItem<String>(
                                            value: emp.nombre,
                                            child: Text(emp.nombre!),
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
                  child: TextField(
                    controller: notasController,
                    decoration: InputDecoration(labelText: "Observaciones"),
                    style: Theme.of(context).textTheme.headline6,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 6, // when user presses enter it will adapt to it
                  ))
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
                        _actualizarAseo(un_aseo!);
                      } else {
                        _insertarAseo();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _selectTimeInicio() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time_ini,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null) {
      setState(() {
        _time_ini = newTime;
        _time_end = newTime.plusMinutes(15);
        inicioController.text = '${newTime.format(context)}';
        finController.text = '${newTime.format(context)}';
        duracionController.text = '${_duration(_time_ini, _time_end)}';
      });
    }
  }

  _selectTimeFin() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time_ini,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null) {
      setState(() {
        _time_end = newTime.plusMinutes(15);
        finController.text = '${newTime.format(context)}';
        duracionController.text = '${_duration(_time_ini, _time_end)}';
      });
    }
  }

  _insertarAseo() async {
    final un_aseo = aseo(
      id_aseo: M.ObjectId(),
      fecha_dia: fecha_diaController.text,
      inicio: inicioController.text,
      fin: finController.text,
      duracion: duracionController.text,
      habitacion: habitacionController.text,
      empleado: empleadoController.text,
      notas: notasController.text,
    );
    await mdb.insertarAseo(un_aseo);
  }

  _actualizarAseo(aseo un_aseo) async {
    final un_bas = aseo(
      id_aseo: un_aseo.id_aseo,
      fecha_dia: fecha_diaController.text,
      inicio: inicioController.text,
      fin: finController.text,
      duracion: duracionController.text,
      habitacion: habitacionController.text,
      empleado: empleadoController.text,
      notas: notasController.text,
    );
    await mdb.actualizarAseo(un_bas);
  }

  @override
  void dispose() {
    super.dispose();
    inicioController.dispose();
    finController.dispose();
    duracionController.dispose();
    habitacionController.dispose();
    empleadoController.dispose();
    notasController.dispose();
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
