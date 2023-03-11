import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarProducto.dart';
import 'package:las_flores/UI/items/itemInventario.dart';
import 'package:las_flores/UI/items/itemProducto.dart';
import 'package:las_flores/UI/otros/productos.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/modelos/modelos.dart';

class inventarios extends StatefulWidget {
  @override
  _inventariosState createState() => _inventariosState();
}

class _inventariosState extends State<inventarios> {
  String fecha = "";
  List<producto> prods = [];
  @override
  Widget build(BuildContext context) {
    dia un_dia;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fecha = un_dia.Fecha;
    }
    prods = [];
    return Scaffold(
        appBar: AppBar(
          title: Text("Inventario en Curso : " + fecha),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Und.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 6,
                            child: Text(
                              "  Producto",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "Pre (\$)",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "Val (\$)",
                              textAlign: TextAlign.right,
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
                                            child: itemProducto(
                                                un_producto: p,
                                                tapBorrar: () async {
                                                  _eliminarInventario(
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
                                                            arguments: servicio
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
                ElevatedButton(
                  onPressed: (() => _insertarInventario()),
                  child: Text("Guardar registro"),
                )
              ]))
        ]));
  }

  _insertarInventario() async {
    prods.forEach((element) async {
      var valor =
          (double.parse(element.existencia) * double.parse(element.existencia))
              .toString();
      final un_inventario = inventario(
          id_inventario: M.ObjectId(),
          fecha_inventario: fecha,
          nombre_producto: element.nombre,
          precio: element.precio_venta,
          cantidad: element.existencia,
          valor: valor);
      await mdb.insertarInventario(un_inventario);
    });
    Navigator.pop(context);
    //await mdb.borrarInventario(fecha);
  }

  _eliminarInventario(producto un_inventario) async {
    showAlertDialog(context, un_inventario);
  }

  showAlertDialog(BuildContext context, producto un_inventario) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarProducto(un_inventario);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content:
          Text("Desea eliminar el inventario de " + un_inventario.nombre + "?"),
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
