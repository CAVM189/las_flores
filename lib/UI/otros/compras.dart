import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarCompra.dart';
import 'package:las_flores/UI/items/itemCompra.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class compras extends StatefulWidget {
  @override
  _comprasState createState() => _comprasState();
}

class _comprasState extends State<compras> {
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    return FutureBuilder(
      future: mdb.getCompras(),
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
            appBar: AppBar(title: Text("Compras del " + fecha)), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemCompra(
                        numero: "",
                        una_compra: compra.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarCompra(compra.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarCompra();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        compra.fromMap(snapshot.data[index]),
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
                          return actualizarCompra();
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

  _eliminarCompra(compra una_compra) async {
    showAlertDialog(context, una_compra);
  }

  showAlertDialog(BuildContext context, compra una_compra) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.restarExProducto(una_compra.producto, una_compra.cantidad);
        await mdb.borrarCompra(una_compra);
        Navigator.of(context).pop(true);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la compra " +
          una_compra.fecha_compra +
          " | Prod:" +
          una_compra.producto +
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
