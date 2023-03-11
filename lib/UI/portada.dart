import 'package:las_flores/UI/items/itemDia.dart';
import 'package:las_flores/UI/actualizar/actualizarDia.dart';
import 'package:flutter/material.dart';
import 'package:las_flores/UI/servicios.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:las_flores/bd/jsonlocaldb.dart' as H;

class portada extends StatefulWidget {
  @override
  _PortadaState createState() => _PortadaState();
}

class _PortadaState extends State<portada> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mdb.getDias(),
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
            appBar: AppBar(title: Text("Dias")), //title
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    /*items/Item_dia.dart como child de listado */
                    child: itemDia(
                        /*required un_dia en items/item_dia.dart */
                        un_dia: dia.fromMap(snapshot.data[index]),
                        /*required  tapBorrar en items/item_dia.dart */
                        tapBorrar: () async {
                          _eliminarDia(dia.fromMap(snapshot.data[index]));
                        },
                        /*required tapActualizar en items/item_dia.dart */
                        tapActualizar: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    /*Accion "Actualizar" llama a constructor de actualizar/actualizarDia*/
                                    return actualizarDia();
                                  },
                                  settings: RouteSettings(
                                    /*RouteSettings envia el mapeo del objeto del 
                                    item seleccionado identificado mediante el "[index]"
                                    para llenar la variable posible "dia? un_dia"
                                    si es actualizacion. Si la variable va vacia, como
                                    en el caso de crear, el constructor de actualizarDia()
                                    cargara el sitio sin valores para crear y almacenar
                                    desde cero un objeto "Dia"*/
                                    arguments:
                                        dia.fromMap(snapshot.data[index]),
                                  ))).then((value) => setState(() {}));
                        },
                        tapVer: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    /*Accion "Actualizar" llama a constructor de actualizar/actualizarDia*/
                                    return servicios();
                                  },
                                  settings: RouteSettings(
                                    /*RouteSettings envia el mapeo del objeto del 
                                    item seleccionado identificado mediante el "[index]"
                                    para llenar la variable posible "dia? un_dia"
                                    si es actualizacion. Si la variable va vacia, como
                                    en el caso de crear, el constructor de actualizarDia()
                                    cargara el sitio sin valores para crear y almacenar
                                    desde cero un objeto "Dia"*/
                                    arguments:
                                        dia.fromMap(snapshot.data[index]),
                                  ))).then((value) => setState(() {}));
                        }));
              },
              itemCount: snapshot.data.length,
            ),
            floatingActionButton: FloatingActionButton(
              //boton flotante
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  /*Boton actualizar llama a constructor "actualizarDia()"
                    pero sin enviar valores a la variable Dia? porque el 
                    proposito de este boton es crear un nuevo registro desde cero*/
                  return actualizarDia();
                })).then((value) => setState(() {}));
              },
              /*Icono "+"*/
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  _eliminarDia(dia un_dia) async {
    showAlertDialog(context, un_dia);
  }

  showAlertDialog(BuildContext context, dia un_dia) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarDia(un_dia);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el dia " + un_dia.Fecha + "?"),
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
