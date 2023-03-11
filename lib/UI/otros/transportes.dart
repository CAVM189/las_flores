import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarTransporte.dart';
import 'package:las_flores/UI/items/itemTransporte.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class transportes extends StatefulWidget {
  @override
  _transportesState createState() => _transportesState();
}

class _transportesState extends State<transportes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mdb.getTransporte(),
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
            appBar: AppBar(title: Text("Transportes")), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemTransporte(
                        un_transporte: transporte.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarTransporte(
                              transporte.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarTransporte();
                                  },
                                  settings: RouteSettings(
                                    arguments: transporte
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
                  return actualizarTransporte();
                })).then((value) => setState(() {}));
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  _eliminarTransporte(transporte un_transporte) async {
    showAlertDialog(context, un_transporte);
  }

  showAlertDialog(BuildContext context, transporte un_transporte) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarTransporte(un_transporte);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content:
          Text("Desea eliminar el transporte tipo " + un_transporte.tipo + "?"),
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
