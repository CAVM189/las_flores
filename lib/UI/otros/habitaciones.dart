import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarHabitacion.dart';
import 'package:las_flores/UI/items/itemHabitacion.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class habitaciones extends StatefulWidget {
  @override
  _habitacionesState createState() => _habitacionesState();
}

class _habitacionesState extends State<habitaciones> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mdb.getHabitaciones(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              child:
                  const LinearProgressIndicator(backgroundColor: Colors.black));
        } else if (snapshot.hasError) {
          return Container(
              color: Colors.white,
              child: Center(
                  child: Text("Error de conexión",
                      style: Theme.of(context).textTheme.headline6)));
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Habitaciones")), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemHabitacion(
                        una_habitacion:
                            habitacion.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarHabitacion(
                              habitacion.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarHabitacion();
                                  },
                                  settings: RouteSettings(
                                    arguments: habitacion
                                        .fromMap(snapshot.data[index]),
                                  ))).then((value) => setState(() {}));
                        }));
              },
              itemCount: snapshot.data.length,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return actualizarHabitacion();
                })).then((value) => setState(() {}));
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  _eliminarHabitacion(habitacion una_habitacion) async {
    showAlertDialog(context, una_habitacion);
  }

  showAlertDialog(BuildContext context, habitacion una_habitacion) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarHabitacion(una_habitacion);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro de la habitación " +
          una_habitacion.numero +
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
}
