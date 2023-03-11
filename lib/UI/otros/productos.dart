import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarProducto.dart';
import 'package:las_flores/UI/items/itemProducto.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

import '../items/itemEditarProducto.dart';

class productos extends StatefulWidget {
  @override
  _productosState createState() => _productosState();
}

class _productosState extends State<productos> {
  List<producto> prods = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Productos"),
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
                              "Cant.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              "  Producto",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "Precio (\$)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                      ])
                    ])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FutureBuilder(
                      future: mdb.getProductos(),
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
                                        var p = producto
                                            .fromMap(snapshot.data[index]);

                                        if (!prods.contains(p)) {
                                          prods.add(p);
                                        }

                                        return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: itemEditarProducto(
                                                un_producto: p,
                                                tapBorrar: () async {
                                                  _eliminarProducto(
                                                      producto.fromMap(snapshot
                                                          .data[index]));
                                                },
                                                tapActualizar: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                              context) {
                                                            return actualizarProducto();
                                                          },
                                                          settings:
                                                              RouteSettings(
                                                            arguments: producto
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
                      return actualizarProducto();
                    })).then((value) => setState(() {}));
                  },
                  child: Icon(Icons.add),
                ),
              ]))
        ]));
  }

  _eliminarProducto(producto un_producto) async {
    showAlertDialog(context, un_producto);
  }

  showAlertDialog(BuildContext context, producto un_producto) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarProducto(un_producto);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el producto " + un_producto.nombre + "?"),
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
