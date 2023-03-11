import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarGasto.dart';
import 'package:las_flores/UI/items/itemGastos.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class gastos extends StatefulWidget {
  @override
  _gastosState createState() => _gastosState();
}

class _gastosState extends State<gastos> {
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    return FutureBuilder(
      future: mdb.getGastosdelDia(fecha),
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
            appBar: AppBar(title: Text("Gastos del " + fecha)), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemGastos(
                        numero: "",
                        un_gasto: gasto.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarGasto(gasto.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarGasto();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        gasto.fromMap(snapshot.data[index]),
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
                          return actualizarGasto();
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

  _eliminarGasto(gasto un_gasto) async {
    showAlertDialog(context, un_gasto);
  }

  showAlertDialog(BuildContext context, gasto un_gasto) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarGasto(un_gasto);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro de " +
          un_gasto.fecha_dia +
          "| Cant:\$" +
          un_gasto.cantidad +
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
