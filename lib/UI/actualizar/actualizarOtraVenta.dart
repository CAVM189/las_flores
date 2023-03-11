import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:las_flores/UI/otros/txtNumbersOnly.dart';

class actualizarOtraVenta extends StatefulWidget {
  @override
  _actualizarOtraVentaState createState() => _actualizarOtraVentaState();
}

M.ObjectId? id_servicio;

class _actualizarOtraVentaState extends State<actualizarOtraVenta> {
  static const Actualizar = 1;
  static const Crear = 0;
  String? dropdownValue_producto;
  TextEditingController fechaController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController disponibilidadController = TextEditingController();
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    var textWidget;
    int operacion = Crear;
    otraventa? una_venta;
    String? cant;
    List<producto> lista_productos = [];

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        una_venta = ModalRoute.of(context)?.settings.arguments as otraventa;

        fechaController.text = una_venta.fecha_venta;
        productoController.text = una_venta.producto;
        cantidadController.text = una_venta.cantidad;
        precioController.text = una_venta.precio;
        totalController.text = una_venta.total;
        operacion = Actualizar;
        textWidget = "Actualizar venta!";
      } catch (e) {
        List<Object?> a =
            ModalRoute.of(context)?.settings.arguments! as List<Object?>;
        fechaController.text = a[0].toString();
        textWidget = "Añadir venta al dia " + fechaController.text;
      }
    }

    return WillPopScope(
        onWillPop: () async {
          dropdownValue_producto = null;
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(textWidget),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    dropdownValue_producto = null;
                    Navigator.pop(context, true);
                  }),
            ),
            body: Stack(children: [
              SingleChildScrollView(
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            )),
                        Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: CheckboxListTile(
                                    title: Text("Cortesía?"),
                                    value: _isChecked,
                                    onChanged: (val) {
                                      setState(() {
                                        precioController.text = "0";
                                        totalController.text = "0";
                                        dropdownValue_producto = null;
                                        _isChecked = val!;
                                      });
                                    })))
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  "Productos",
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                      Expanded(
                          flex: 5,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: FutureBuilder(
                                future: mdb.getProductos(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (una_venta != null) {
                                    return Padding(
                                        padding: const EdgeInsets.all(0),
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
                                              hint: Text(
                                                  dropdownValue_producto ??
                                                      'Seleccionar producto'),
                                              onChanged: (value) {
                                                //producto p = producto.fromMap();
                                                setState(() {
                                                  dropdownValue_producto =
                                                      value;
                                                  productoController.text =
                                                      dropdownValue_producto!;
                                                  var pre = lista_productos
                                                      .where((element) =>
                                                          element.nombre ==
                                                          dropdownValue_producto)
                                                      .first;
                                                  precioController.text =
                                                      pre.precio_venta;
                                                  disponibilidadController
                                                          .text =
                                                      "" +
                                                          pre.existencia +
                                                          " " +
                                                          pre.nombre +
                                                          " en existencia. ";
                                                  if (_isChecked == false) {
                                                    precioController.text =
                                                        pre.precio_venta;
                                                  } else {
                                                    precioController.text = "0";
                                                  }
                                                });
                                              },
                                              value: dropdownValue_producto,
                                              items: snapshot.data.map<
                                                      DropdownMenuItem<String>>(
                                                  (item) {
                                                var prod =
                                                    producto.fromMap(item);
                                                lista_productos.add(prod);

                                                //prod.precio_venta;
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
                              ))),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: txtNumbersOnly(
                                  tapCalcular: () {
                                    calcularValores();
                                  },
                                  cantidadController: cantidadController,
                                  disponibilidadController:
                                      disponibilidadController,
                                ))),
                      ]),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: precioController,
                        readOnly: true,
                        decoration:
                            InputDecoration(labelText: "Precio de Venta (\$)"),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: totalController,
                        decoration: InputDecoration(labelText: "Valor Total"),
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
                            _actualizarOtraVenta(una_venta!);
                          } else {
                            _insertarOtraVenta();
                          }
                        }),
                  ))
            ])));
  }

  calcularValores() {
    try {
      var pre = double.parse(precioController.text);
      var can = int.parse(cantidadController.text);
      totalController.text = (can * pre).toStringAsFixed(2);
    } catch (e) {}
  }

  _insertarOtraVenta() async {
    try {
      if (_isChecked) {
        productoController.text = dropdownValue_producto!;
        final una_venta = otraventa(
            id_otraventa: M.ObjectId(),
            fecha_venta: fechaController.text,
            producto: productoController.text,
            cantidad: cantidadController.text,
            precio: "0",
            total: "'0'");

        bool ev = false;
        await mdb
            .restarExProducto(una_venta.producto, una_venta.cantidad)
            .then((value) => ev = value);
        if (ev == true) {
          await mdb.insertarOtraVenta(una_venta);
          Navigator.pop(context);
        } else {
          return showAlertDialogV(context, una_venta.producto);
        }
      } else {
        productoController.text = dropdownValue_producto!;
        final una_venta = otraventa(
            id_otraventa: M.ObjectId(),
            fecha_venta: fechaController.text,
            producto: productoController.text,
            cantidad: cantidadController.text,
            precio: precioController.text,
            total: totalController.text);

        bool ev = false;
        await mdb
            .restarExProducto(una_venta.producto, una_venta.cantidad)
            .then((value) => ev = value);
        if (ev == true) {
          await mdb.insertarOtraVenta(una_venta);
          await mdb.actualizarEfDia(una_venta.fecha_venta, una_venta.total);
          Navigator.pop(context);
        } else {
          return showAlertDialogV(context, una_venta.producto);
        }
      }
    } catch (e) {}
  }

  showAlertDialogV(BuildContext context, String producto) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Inventario insuficiente"),
      content: Text("No hay suficientes unidades de " + producto),
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

  _actualizarOtraVenta(otraventa una_venta) async {
    try {
      final un_ven = otraventa(
          id_otraventa: una_venta.id_otraventa,
          fecha_venta: fechaController.text,
          producto: productoController.text,
          cantidad: cantidadController.text,
          precio: precioController.text,
          total: totalController.text);
      await mdb.actualizarOtraVenta(un_ven);
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
    productoController.dispose();
    cantidadController.dispose();
  }
}
