import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarCortesia extends StatefulWidget {
  @override
  _actualizarCortesiaState createState() => _actualizarCortesiaState();
}

M.ObjectId? id_servicio;
String? dropdownValue_producto;

class _actualizarCortesiaState extends State<actualizarCortesia> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController fechaController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController disponibilidadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<producto> lista_productos = [];
    var textWidget;
    int operacion = Crear;
    cortesia? una_cortesia;
    String? cant;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      try {
        una_cortesia = ModalRoute.of(context)?.settings.arguments as cortesia;
        operacion = Actualizar;
        id_servicio = una_cortesia.id_servicio;
        fechaController.text = una_cortesia.fecha_venta;
        productoController.text = una_cortesia.producto;
        cantidadController.text = una_cortesia.cantidad;

        textWidget = "Actualizar Cortesia!";
      } catch (e) {
        List<Object?> a =
            ModalRoute.of(context)?.settings.arguments! as List<Object?>;
        fechaController.text = a[1].toString();
        cant = (int.parse(a[2].toString()) + 1).toString();
        id_servicio = a[0] as M.ObjectId;
        textWidget =
            "+ Cortesia al servicio #" + cant + " del " + fechaController.text;
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
                                    const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Text(
                                  "Productos",
                                  style: Theme.of(context).textTheme.headline6,
                                ))),
                      ),
                      Expanded(
                          flex: 4,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: FutureBuilder(
                                future: mdb.getProductosExistentes(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (una_cortesia != null) {
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
                                                      'Seleccionar Producto'),
                                              onChanged: (value) {
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: TextField(
                                controller: cantidadController,
                                decoration:
                                    InputDecoration(labelText: "Cantidad"),
                              )),
                        ],
                      )),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Text(
                        disponibilidadController.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ))
                ]),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: ElevatedButton(
                        child: Text("Guardar"),
                        onPressed: () {
                          var r = _insertarCortesia();

                          //
                        }),
                  ))
            ])));
  }

  _insertarCortesia() async {
    try {
      if (cantidadController.text == "") {
        return showAlertDialogV(
            context, "", "Error", "Ingrese la cantidad deseada!");
      } else {
        productoController.text = dropdownValue_producto!;
        final una_cortesia = cortesia(
            id_cortesia: M.ObjectId(),
            id_servicio: id_servicio!,
            fecha_venta: fechaController.text,
            producto: productoController.text,
            cantidad: cantidadController.text);

        bool ev = false;
        await mdb
            .restarExProducto(una_cortesia.producto, una_cortesia.cantidad)
            .then((value) => ev = value);
        if (ev == true) {
          await mdb.insertarCortesia(una_cortesia);
          dropdownValue_producto = null;
          Navigator.pop(context);
        } else {
          return showAlertDialogV(context, una_cortesia.producto,
              "Inventario insuficiente", "No hay suficientes unidades de ");
        }
      }
    } catch (e) {
      int i = 0;
    }
  }

  showAlertDialogV(
      BuildContext context, String producto, String titulo, String mensaje) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensaje + producto!),
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
