import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarEmpleado.dart';
import 'package:las_flores/UI/actualizar/actualizarRemesa.dart';
import 'package:las_flores/UI/items/itemRemesa.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class remesas extends StatefulWidget {
  @override
  _remesasState createState() => _remesasState();
}

class _remesasState extends State<remesas> {
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    return FutureBuilder(
      future: mdb.getRemesasDia(fecha),
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
            appBar: AppBar(title: Text("Remesas del " + fecha)), //title

            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemRemesa(
                        una_remesa: remesa.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarRemesa(remesa.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarRemesa();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        remesa.fromMap(snapshot.data[index]),
                                  ))).then((value) => setState(() {}));
                        }));
              },
              itemCount: snapshot.data.length,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return actualizarRemesa();
                        },
                        settings: RouteSettings(
                          arguments: fecha,
                        ))).then((value) => setState(() {}));
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  _eliminarRemesa(remesa un_remesa) async {
    showAlertDialog(context, un_remesa);
  }

  showAlertDialog(BuildContext context, remesa un_remesa) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarRemesa(un_remesa);
        await mdb.actualizarEfDia(un_remesa.fecha_dia, un_remesa.cantidad);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content:
          Text("Desea eliminar la remesa \"" + un_remesa.recibio + "" + "?"),
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
