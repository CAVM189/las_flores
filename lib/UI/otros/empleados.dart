import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarEmpleado.dart';
import 'package:las_flores/UI/items/itemEmpleado.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class empleados extends StatefulWidget {
  @override
  _empleadosState createState() => _empleadosState();
}

class _empleadosState extends State<empleados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Empleados"),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Nombre",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "  DUI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                      ])
                    ])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FutureBuilder(
                      future: mdb.getEmpleados(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              double.parse(snapshot.data.length.toString()) *
                                  70;

                          return Row(children: <Widget>[
                            Expanded(
                                child: SizedBox(
                                    height: s,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        var p = empleado
                                            .fromMap(snapshot.data[index]);

                                        return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: item_Empleado(
                                                un_empleado: p,
                                                tapBorrar: () async {
                                                  _eliminarEmpleado(
                                                      empleado.fromMap(snapshot
                                                          .data[index]));
                                                },
                                                tapActualizar: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return actualizarEmpleado();
                                                          },
                                                          settings:
                                                              RouteSettings(
                                                            arguments: empleado
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
                                    )))
                          ]);
                        }
                      },
                    )),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return actualizarEmpleado();
                    })).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              ]))
        ]));
  }

  _eliminarEmpleado(empleado un_empleado) async {
    showAlertDialog(context, un_empleado);
  }

  showAlertDialog(BuildContext context, empleado un_empleado) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarEmpleado(un_empleado);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content:
          Text("Desea eliminar el registro de " + un_empleado.nombre + "?"),
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
