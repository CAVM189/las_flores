import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';

class actualizarTransporte extends StatefulWidget {
  @override
  _actualizarTransporteState createState() => _actualizarTransporteState();
}

class _actualizarTransporteState extends State<actualizarTransporte> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController tipoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Transporte";
    int operacion = Crear;
    transporte? un_transporte;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      operacion = Actualizar;
      un_transporte = ModalRoute.of(context)?.settings.arguments as transporte;
      tipoController.text = un_transporte.tipo;
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
                    controller: tipoController,
                    decoration: InputDecoration(labelText: "Tipo"),
                  )),
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
                        _actualizarTransporte(un_transporte!);
                      } else {
                        _insertarTransporte();
                      }
                      Navigator.pop(context);
                    }),
              ))
        ]));
  }

  _insertarTransporte() async {
    final un_transporte =
        transporte(id_transporte: M.ObjectId(), tipo: tipoController.text);
    await mdb.insertarTransporte(un_transporte);
  }

  _actualizarTransporte(transporte un_transporte) async {
    final un_t = transporte(
      id_transporte: un_transporte.id_transporte,
      tipo: tipoController.text,
    );
    await mdb.actualizarTransporte(un_t);
  }

  @override
  void dispose() {
    super.dispose();
    tipoController.dispose();
  }
}
