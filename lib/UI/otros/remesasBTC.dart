import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarEmpleado.dart';
import 'package:las_flores/UI/actualizar/actualizarRemesaBTC.dart';
import 'package:las_flores/UI/items/itemRemesaBTC.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class remesasBTC extends StatefulWidget {
  @override
  _remesasBTCState createState() => _remesasBTCState();
}

class _remesasBTCState extends State<remesasBTC> {
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    return FutureBuilder(
      future: mdb.getRemesasDiaBTC(fecha),
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
            appBar: AppBar(title: Text("Remesas en BTC del " + fecha)), //title

            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemRemesaBTC(
                        una_remesa: remesaBTC.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarRemesaBTC(
                              remesaBTC.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarRemesaBTC();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        remesaBTC.fromMap(snapshot.data[index]),
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
                          return actualizarRemesaBTC();
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

  _eliminarRemesaBTC(remesaBTC un_remesa) async {
    showAlertDialog(context, un_remesa);
  }

  showAlertDialog(BuildContext context, remesaBTC un_remesa) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarRemesaBTC(un_remesa);
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
