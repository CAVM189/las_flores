import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarAseo.dart';
import 'package:las_flores/UI/items/itemAseo.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class aseos extends StatefulWidget {
  @override
  _aseosState createState() => _aseosState();
}

class _aseosState extends State<aseos> {
  int numeroA = 0;
  @override
  Widget build(BuildContext context) {
    String fecha = "";
    dia un_dia;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }

    return FutureBuilder(
      future: mdb.getAseosdelDia(fecha),
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
            appBar: AppBar(title: Text("Aseos del " + fecha)), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: itemAseo(
                        numero: (numeroA = numeroA + 1).toString(),
                        un_aseo: aseo.fromMap(snapshot.data[index]),
                        tapBorrar: () async {
                          _eliminarAseo(aseo.fromMap(snapshot.data[index]));
                        },
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarAseo();
                                  },
                                  settings: RouteSettings(
                                    arguments:
                                        aseo.fromMap(snapshot.data[index]),
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
                          return actualizarAseo();
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

  _eliminarAseo(aseo un_aseo) async {
    showAlertDialog(context, un_aseo);
  }

  showAlertDialog(BuildContext context, aseo un_aseo) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarAseo(un_aseo);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro del " +
          un_aseo.fecha_dia +
          "|" +
          un_aseo.inicio +
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
