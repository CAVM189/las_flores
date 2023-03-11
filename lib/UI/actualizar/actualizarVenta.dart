import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

import '../otros/txtNumbersOnly.dart';

class actualizarVenta extends StatefulWidget {
  @override
  _actualizarVentaState createState() => _actualizarVentaState();
}

M.ObjectId? id_servicio;

class _actualizarVentaState extends State<actualizarVenta> {
  static const Actualizar = 1;
  static const Crear = 0;
  String? dropdownValue_producto;
  TextEditingController fechaController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController disponibilidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget;
    int operacion = Crear;
    venta? una_venta;
    String? cant;
    List<producto> lista_productos = [];

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        una_venta = ModalRoute.of(context)?.settings.arguments as venta;
        operacion = Actualizar;
        id_servicio = una_venta.id_servicio;
        fechaController.text = una_venta.fecha_venta;
        productoController.text = una_venta.producto;
        cantidadController.text = una_venta.cantidad;
        precioController.text = una_venta.precio;
        totalController.text = una_venta.total;
        textWidget = "Actualizar venta!";
      } catch (e) {
        List<Object?> a =
            ModalRoute.of(context)?.settings.arguments! as List<Object?>;
        fechaController.text = a[1].toString();
        cant = (int.parse(a[2].toString()) + 1).toString();
        id_servicio = a[0] as M.ObjectId;
        textWidget = "Añadir venta al servicio #" +
            cant +
            " del " +
            fechaController.text;
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
                    })),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                                future: mdb.getProductosExistentes(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (una_venta != null) {
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
                                                      " " +
                                                          pre.existencia +
                                                          " " +
                                                          pre.nombre +
                                                          " en existencia. ";
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
                              )))
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: txtNumbersOnly(
                        tapCalcular: () {
                          calcularValores();
                        },
                        cantidadController: cantidadController,
                        disponibilidadController: disponibilidadController,
                      )),
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
                        decoration:
                            InputDecoration(labelText: "Valor Total (\$)"),
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
                          _insertarVenta();
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

  _insertarVenta() async {
    try {
      if (cantidadController.text == "") {
        return showAlertDialogV(
            context, "", "Error", "Ingrese la cantidad deseada!");
      } else {
        productoController.text = dropdownValue_producto!;
        final una_venta = venta(
            id_venta: M.ObjectId(),
            id_servicio: id_servicio!,
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
          await mdb.actualizarEfDia(una_venta.fecha_venta, una_venta.total);
          await mdb.insertarVenta(una_venta);
          dropdownValue_producto = null;
          Navigator.pop(context);
        } else {
          return showAlertDialogV(context, una_venta.producto,
              "Inventario insuficiente", "No hay suficientes unidades de ");
        }
      }
    } catch (e) {}
  }

  showAlertDialogV(
      BuildContext context, String producto, String titulo, String mensaje) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensaje + producto),
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

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
    productoController.dispose();
    cantidadController.dispose();
  }
}
