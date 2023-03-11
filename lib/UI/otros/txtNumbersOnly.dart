import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:las_flores/modelos/modelos.dart';

class txtNumbersOnly extends StatelessWidget {
  txtNumbersOnly(
      {required this.cantidadController,
      required this.disponibilidadController,
      required this.tapCalcular});

  final TextEditingController cantidadController;
  final TextEditingController disponibilidadController;
  String? value;
  String label = "";
  Function? onChanged;
  String? error;
  Widget? icon;
  bool allowDecimal = true;

  final VoidCallback tapCalcular;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: TextField(
                controller: cantidadController,
                onChanged: ((value) => tapCalcular()),
                /*decoration:
                                    InputDecoration(labelText: "Cantidad"),*/
                keyboardType:
                    TextInputType.numberWithOptions(decimal: allowDecimal),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll('.', ','),
                    ),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: "Cantidad",
                  errorText: error,
                  icon: icon,
                ),

                ///onChanged: (value) => {_calcularValores()},
              )),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    disponibilidadController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )))
        ],
      ),
    );
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
