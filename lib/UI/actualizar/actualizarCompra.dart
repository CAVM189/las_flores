import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:flutter/cupertino.dart';

import '../otros/txtNumbersOnly.dart';

class actualizarCompra extends StatefulWidget {
  @override
  _actualizarCompraState createState() => _actualizarCompraState();
}

class _actualizarCompraState extends State<actualizarCompra> {
  static const Actualizar = 1;
  static const Crear = 0;
  String? dropdownValue_producto;

  TextEditingController fechaController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Compra";
    int operacion = Crear;
    compra? una_compra;
    String? un_dia;
    List<producto> lista_productos = [];

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        una_compra = ModalRoute.of(context)?.settings.arguments as compra;
        operacion = Actualizar;
        fechaController.text = una_compra.fecha_compra;
        productoController.text = una_compra.producto;
        cantidadController.text = una_compra.cantidad;
        precioController.text = una_compra.precio;
        totalController.text = una_compra.total;
        textWidget = "Actualizar!";
      } catch (e) {
        if (ModalRoute.of(context)?.settings.arguments != null) {
          un_dia = ModalRoute.of(context)?.settings.arguments as String;
          fechaController.text = un_dia;
          textWidget = "Nueva compra del " + un_dia;
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(textWidget),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text(
                              "Productos",
                              style: Theme.of(context).textTheme.headline6,
                            ))),
                  ),
                  Expanded(
                      flex: 4,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getProductos(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (una_compra != null) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: productoController,
                                      readOnly: true,
                                    ));
                              } else {
                                return snapshot.hasData
                                    ? Container(
                                        width: 1000,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text(dropdownValue_producto ??
                                              'Seleccionar Producto'),
                                          onChanged: (value) {
                                            setState(() {
                                              dropdownValue_producto = value;
                                              productoController.text =
                                                  dropdownValue_producto!;
                                              var pre = lista_productos
                                                  .where((element) =>
                                                      element.nombre ==
                                                      dropdownValue_producto)
                                                  .first
                                                  .precio_venta;
                                              //precioController.text = pre;
                                            });
                                          },
                                          value: dropdownValue_producto,
                                          items: snapshot.data
                                              .map<DropdownMenuItem<String>>(
                                                  (item) {
                                            var prod = producto.fromMap(item);
                                            lista_productos.add(prod);
                                            return DropdownMenuItem<String>(
                                              value: prod.nombre,
                                              child: Text(prod.nombre!),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : Container(
                                        child: Center(
                                          child: Text('Cargando...'),
                                        ),
                                      );
                              }
                            },
                          )))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: txtNumbersOnly(
                      tapCalcular: () {
                        _calcularValores();
                      },
                      cantidadController: cantidadController,
                      disponibilidadController: new TextEditingController())),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: precioController,
                    decoration: InputDecoration(
                        labelText: "Precio de compra por unidad"),
                    onChanged: (String value) async {
                      try {
                        var s = double.parse(value) * 2;
                        _calcularValores();
                        return;
                      } catch (e) {}
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: totalController,
                    decoration: InputDecoration(labelText: "Total"),
                    readOnly: true,
                  )),
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text("Guardar"),
                    onPressed: () {
                      if (operacion == Actualizar) {
                        _actualizarCompra(una_compra!);
                      } else {
                        _insertarCompra();
                      }
                    }),
              ))
        ]));
  }

  _calcularValores() {
    if (precioController.text == "") {
      precioController.text = "0";
    }
    if (cantidadController.text == "") {
      cantidadController.text = "0";
    }

    var pre = double.parse(precioController.text);
    var can = int.parse(cantidadController.text);
    totalController.text = (can * pre).toStringAsFixed(2);
  }

  _insertarCompra() async {
    if (fechaController.text == "" ||
        productoController.text == "" ||
        cantidadController.text == "" ||
        precioController.text == "" ||
        totalController.text == "") {
      showAlertDialog(context);
    } else {
      final una_compra = compra(
          id_compra: M.ObjectId(),
          fecha_compra: fechaController.text,
          producto: productoController.text,
          cantidad: cantidadController.text,
          precio: precioController.text,
          total: totalController.text);
      await mdb.actualizarExProducto(una_compra.producto, una_compra.cantidad);
      await mdb.restarEfDia(una_compra.fecha_compra, una_compra.cantidad);
      await mdb.insertarCompra(una_compra);
      Navigator.pop(context);
    }
  }

  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Erro"),
      content: Text("Complete todos los datos necesarios"),
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

  _actualizarCompra(compra una_compra) async {
    if (dropdownValue_producto != productoController.text) {
      productoController.text = dropdownValue_producto!;
    }
    final un_com = compra(
      id_compra: una_compra.id_compra,
      fecha_compra: fechaController.text,
      producto: productoController.text,
      cantidad: cantidadController.text,
      precio: precioController.text,
      total: totalController.text,
    );
    await mdb.actualizarCompra(un_com);
  }

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
    productoController.dispose();
    cantidadController.dispose();
    precioController.dispose();
    totalController.dispose();
  }
}
