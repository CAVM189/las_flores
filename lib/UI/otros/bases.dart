import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarBase.dart';
import 'package:las_flores/UI/items/itemBase.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class bases extends StatefulWidget {
  @override
  _basesState createState() => _basesState();
}

class _basesState extends State<bases> {
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    return FutureBuilder(
      future: mdb.getBases(),
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
            appBar: AppBar(title: Text("Bases del " + fecha)), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemBase(
                        una_base: base.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarbase(base.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarBase();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        base.fromMap(snapshot.data[index]),
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
                          return actualizarBase();
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

  _eliminarbase(base un_base) async {
    showAlertDialog(context, un_base);
  }

  showAlertDialog(BuildContext context, base un_base) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarBase(un_base);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro de " + un_base.fecha_dia + "?"),
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
