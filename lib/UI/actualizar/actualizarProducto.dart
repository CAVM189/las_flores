import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarProducto extends StatefulWidget {
  @override
  _actualizarProductoState createState() => _actualizarProductoState();
}

class _actualizarProductoState extends State<actualizarProducto> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController existenciaController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Producto";
    int operacion = Crear;
    producto? un_producto;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      operacion = Actualizar;
      un_producto = ModalRoute.of(context)?.settings.arguments as producto;
      nombreController.text = un_producto.nombre;
      precioController.text = un_producto.precio_venta;
      existenciaController.text = un_producto.existencia;
      valorController.text = un_producto.valor;
      textWidget = "Actualizar!";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(textWidget),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nombreController,
                    decoration: InputDecoration(labelText: "Nombre"),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: precioController,
                    decoration:
                        InputDecoration(labelText: "Precio de Venta (\$)"),
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
                    controller: existenciaController,
                    decoration: InputDecoration(labelText: "Existencia"),
                    readOnly: true,
                  )),
              /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: valorController,
                    decoration: InputDecoration(labelText: "Valor Total"),
                    readOnly: true,
                  )),*/
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ElevatedButton(
                    child: Text(textWidget),
                    onPressed: () {
                      if (operacion == Actualizar) {
                        _actualizarProducto(un_producto!);
                      } else {
                        _insertarProducto();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _calcularValores() {
    if (precioController.text == "") {
      precioController.text = "0";
    }
    if (existenciaController.text == "") {
      existenciaController.text = "0";
    }

    var pre = double.parse(precioController.text);
    var tot = int.parse(existenciaController.text);
    valorController.text = (tot * pre).toString();
    //setState(() {});
  }

  _insertarProducto() async {
    final un_producto = producto(
        id_producto: M.ObjectId(),
        nombre: nombreController.text,
        precio_venta: precioController.text,
        existencia: existenciaController.text,
        valor: valorController.text);
    await mdb.insertarProducto(un_producto);
  }

  _actualizarProducto(producto un_producto) async {
    final un_prod = producto(
        id_producto: un_producto.id_producto,
        nombre: nombreController.text,
        precio_venta: precioController.text,
        existencia: existenciaController.text,
        valor: valorController.text);
    await mdb.actualizarProducto(un_prod);
  }

  @override
  void dispose() {
    super.dispose();
    nombreController.dispose();
  }
}
