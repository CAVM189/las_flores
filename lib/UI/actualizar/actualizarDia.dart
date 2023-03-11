import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/bd/jsonlocaldb.dart' as J;
import 'package:las_flores/modelos/modelos.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class actualizarDia extends StatefulWidget {
  @override
  _actualizarDiaState createState() => _actualizarDiaState();
}

class _actualizarDiaState extends State<actualizarDia> {
  static const Actualizar = 1;
  static const Crear = 0;

  TextEditingController fechaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var textWidget = "Añadir Dia";
    int operacion = Crear;
    dia? un_dia;

/*La condicional siguiente evalua si la variable en "settings"
trae algun valor que se pueda almacenar en la variable "un_dia"*/
    if (ModalRoute.of(context)?.settings.arguments != null) {
      operacion = Actualizar;
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      fechaController.text = un_dia.Fecha;
      textWidget = "Actualizar!";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(textWidget),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "Fecha"),
                  )),
              SizedBox(
                height: 100,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newDateTime) {
                    fechaController.text = diasEsp(
                        DateFormat('EEEE d MMMM yyyy').format(newDateTime));
                    // Do something
                  },
                ),
              ),
            ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: ElevatedButton(
                      child: Text(textWidget),
                      onPressed: () {
                        if (fechaController.text == "") {
                          showAlertDialogV(
                              context, "Error", "Seleccione la fecha deseada");
                        } else {
                          _insertarDia();
                          //Navigator.pop(context);
                        }
                      })))
        ]));
  }

  String diasEsp(String fullDate) {
    var s = fullDate.replaceAll("Monday", "Lunes");
    s = s.replaceAll("Monday", "Lunes");
    s = s.replaceAll("Tuesday", "Martes");
    s = s.replaceAll("Wednesday", "Miercoles");
    s = s.replaceAll("Thursday", "Jueves");
    s = s.replaceAll("Friday", "Viernes");
    s = s.replaceAll("Saturday", "Sabado");
    s = s.replaceAll("Sunday", "Domingo");
    s = s.replaceAll("January", "Enero");
    s = s.replaceAll("February", "Febrero");
    s = s.replaceAll("March", "Marzo");
    s = s.replaceAll("April", "Abril");
    s = s.replaceAll("May", "Mayo");
    s = s.replaceAll("June", "Junio");
    s = s.replaceAll("July", "Julio");
    s = s.replaceAll("August", "Agosto");
    s = s.replaceAll("September", "Septiembre");
    s = s.replaceAll("October", "Octubre");
    s = s.replaceAll("November", "Noviembre");
    s = s.replaceAll("December", "Diciembre");
    return s;
  }

  _insertarDia() async {
    final un_dia = dia(
      id: null,
      id_dia: M.ObjectId(),
      Fecha: fechaController.text,
      inventario: false.toString(),
      efectivo_base: "0",
      /*efectivo_btc: "0",
      efectivo_compras: "0",
      efectivo_gastos: "0",
      efectivo_remesas: "0",
      efectivo_servicios: "0",
      efectivo_ventas: "0",*/
    );
    //J.jdb.insertarDia(un_dia);
    J.localdb.insertDog(un_dia);
    //J.jdb.saveToStorage(un_dia);
    //await mdb.insertarDia(un_dia);
  }

  showAlertDialogV(BuildContext context, String titulo, String mensaje) {
    Widget continueButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
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

  _actualizarDia(dia un_dia) async {
    final un_d = dia(
      id: null,
      id_dia: un_dia.id_dia,
      Fecha: fechaController.text,
      inventario: un_dia.inventario,
      efectivo_base: un_dia.efectivo_base,
      /*efectivo_btc: un_dia.efectivo_btc,
      efectivo_compras: un_dia.efectivo_compras,
      efectivo_gastos: un_dia.efectivo_gastos,
      efectivo_remesas: un_dia.efectivo_remesas,
      efectivo_servicios: un_dia.efectivo_servicios,
      efectivo_ventas: un_dia.efectivo_ventas,*/
    );
    await mdb.actualizarDia(un_d);
  }

  @override
  void dispose() {
    super.dispose();
    fechaController.dispose();
  }
}
