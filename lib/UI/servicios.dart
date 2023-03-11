import 'package:flutter/material.dart';
import 'package:las_flores/UI/actualizar/actualizarBase.dart';
import 'package:las_flores/UI/actualizar/actualizarServicio.dart';
import 'package:las_flores/UI/items/itemCompra.dart';
import 'package:las_flores/UI/items/itemGastos.dart';
import 'package:las_flores/UI/items/itemServicio.dart';
import 'package:las_flores/UI/otros/inventarios.dart';
import 'package:las_flores/UI/otros/remesas.dart';
import 'package:las_flores/UI/otros/remesasBTC.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'acordion.dart';
import 'actualizar/actualizarAseo.dart';
import 'actualizar/actualizarCompra.dart';
import 'actualizar/actualizarGasto.dart';
import 'actualizar/actualizarProducto.dart';
import 'actualizar/actualizarOtraVenta.dart';
import 'items/itemAseo.dart';
import 'items/itemInventario.dart';
import 'items/itemOtraVenta.dart';

class servicios extends StatefulWidget {
  @override
  _serviciosState createState() => _serviciosState();
}

dia? un_dia;

class _serviciosState extends State<servicios> {
  TextEditingController efe = TextEditingController();
  String mainText = "Servicios";
  List<base> listaBases = [];
  List<servicio> listaServicios = [];
  List<gasto> listaGastos = [];
  List<compra> listaCompras = [];
  List<venta> listaVentas = [];
  List<remesa> listaRemesas = [];

  @override
  Widget build(BuildContext context) {
    List<inventario> prods = [];
    int cant = 0;
    int numeroS = 0;
    int numeroA = 0;
    int numeroG = 0;
    int numeroC = 0;

    if (ModalRoute.of(context)?.settings.arguments != null) {
      un_dia = ModalRoute.of(context)?.settings.arguments as dia;
      if (efe.text == "") {
        efe.text = un_dia!.efectivo_base;
      }

      mainText = un_dia!.Fecha;
    }

    return Scaffold(
        appBar: AppBar(title: Text("Dia " + mainText), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: (() => _actualizar()),
                child: Icon(
                  Icons.update_outlined,
                  size: 40.0,
                ),
              )),
        ]),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: FutureBuilder(
                      future: mdb.getBaseDelDia(mainText),
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
                          var s = double.parse(snapshot.data.length.toString());

                          if (s < 1) {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        "La base del dia no ha sido ingresada!, ",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700))),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return actualizarBase();
                                              },
                                              settings: RouteSettings(
                                                arguments: un_dia!.Fecha,
                                              ))).then((value) {
                                        setState(() {
                                          _actualizar();
                                        });
                                      });
                                    },
                                    child: Text("Añadir Base +"),
                                  ),
                                )
                              ],
                            );
                          } else {
                            String baseTotal = "0";
                            for (int i = 0; i < s; i++) {
                              var b = base.fromMap(snapshot.data[i]);
                              baseTotal = (double.parse(baseTotal) +
                                      double.parse(b.cantidad))
                                  .toString();
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text("Base: \$" + baseTotal,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _eliminarbase(
                                          base.fromMap(snapshot.data[0]));
                                    },
                                    child: Text("Descartar Base"),
                                  ),
                                )
                              ],
                            );
                          }
                        }
                      },
                    )),
                Accordion(
                    title: 'Servicios',
                    content: Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getServiciosdelDia(mainText),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: const LinearProgressIndicator(
                                        backgroundColor: Colors.black));
                              } else if (snapshot.hasError) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: Text("Error de conexión",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)));
                              } else {
                                var servLenght = double.parse(
                                    snapshot.data.length.toString());

                                var s = (servLenght * 50);

                                cant = snapshot.data.length;

                                return Row(children: <Widget>[
                                  Expanded(
                                      child: SizedBox(
                                          height: s,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: itemServicio(
                                                      numero: (numeroS =
                                                              numeroS + 1)
                                                          .toString(),
                                                      un_servicio: servicio
                                                          .fromMap(snapshot
                                                              .data[index]),
                                                      tapBorrar: () async {
                                                        _eliminarServicio(
                                                            servicio.fromMap(
                                                                snapshot.data[
                                                                    index]));
                                                      },
                                                      tapActualizar: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return actualizarServicio();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: servicio
                                                                      .fromMap(snapshot
                                                                              .data[
                                                                          index]),
                                                                ))).then(
                                                            (value) =>
                                                                setState(() {
                                                                  value = value;
                                                                }));
                                                      }));
                                            },
                                            itemCount: snapshot.data.length,
                                          ))),
                                ]);
                              }
                            },
                          )),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarServicio();
                                  },
                                  settings: RouteSettings(
                                    arguments: [un_dia!.Fecha, cant],
                                  ))).then((value) => setState(() {}));
                        },
                        child: Text("Añadir +"),
                      ),
                    ])),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Accordion(
                    title: 'Aseos',
                    content: Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getAseosdelDia(un_dia!.Fecha),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: const LinearProgressIndicator(
                                        backgroundColor: Colors.black));
                              } else if (snapshot.hasError) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: Text("Error de conexión",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)));
                              } else {
                                var s = double.parse(
                                        snapshot.data.length.toString()) *
                                    50;
                                cant = snapshot.data.length;
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: SizedBox(
                                          height: s,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: itemAseo(
                                                      numero: (numeroA =
                                                              numeroA + 1)
                                                          .toString(),
                                                      un_aseo: aseo.fromMap(
                                                          snapshot.data[index]),
                                                      tapBorrar: () async {
                                                        _eliminarAseo(aseo
                                                            .fromMap(snapshot
                                                                .data[index]));
                                                      },
                                                      tapActualizar: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return actualizarAseo();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: aseo
                                                                      .fromMap(snapshot
                                                                              .data[
                                                                          index]),
                                                                ))).then(
                                                            (value) =>
                                                                setState(() {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarAseo();
                                  },
                                  settings: RouteSettings(
                                    arguments: un_dia!.Fecha,
                                  ))).then((value) => setState(() {}));
                        },
                        child: Text("Añadir +"),
                      ),
                    ])),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Accordion(
                    title: 'Gastos',
                    content: Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getGastosdelDia(un_dia!.Fecha),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: const LinearProgressIndicator(
                                        backgroundColor: Colors.black));
                              } else if (snapshot.hasError) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: Text("Error de conexión",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)));
                              } else {
                                var s = double.parse(
                                        snapshot.data.length.toString()) *
                                    50;
                                cant = snapshot.data.length;
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: SizedBox(
                                          height: s,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: itemGastos(
                                                      numero: (numeroG =
                                                              numeroG + 1)
                                                          .toString(),
                                                      un_gasto: gasto.fromMap(
                                                          snapshot.data[index]),
                                                      tapBorrar: () async {
                                                        _eliminarGasto(gasto
                                                            .fromMap(snapshot
                                                                .data[index]));
                                                      },
                                                      tapActualizar: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return actualizarGasto();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: gasto
                                                                      .fromMap(snapshot
                                                                              .data[
                                                                          index]),
                                                                ))).then(
                                                            (value) =>
                                                                setState(() {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarGasto();
                                  },
                                  settings: RouteSettings(
                                    arguments: un_dia!.Fecha,
                                  ))).then((value) => setState(() {}));
                        },
                        child: Text("Añadir +"),
                      ),
                    ])),
                Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                Accordion(
                    title: 'Compras',
                    content: Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: FutureBuilder(
                            future: mdb.getComprasDia(un_dia!.Fecha),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: const LinearProgressIndicator(
                                        backgroundColor: Colors.black));
                              } else if (snapshot.hasError) {
                                cant = 0;
                                return Container(
                                    color: Colors.white,
                                    child: Center(
                                        child: Text("Error de conexión",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6)));
                              } else {
                                var s = double.parse(
                                        snapshot.data.length.toString()) *
                                    50;
                                cant = snapshot.data.length;
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: SizedBox(
                                          height: s,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: itemCompra(
                                                      numero: (numeroC =
                                                              numeroC + 1)
                                                          .toString(),
                                                      una_compra: compra
                                                          .fromMap(snapshot
                                                              .data[index]),
                                                      tapBorrar: () async {
                                                        _eliminarCompra(compra
                                                            .fromMap(snapshot
                                                                .data[index]));
                                                      },
                                                      tapActualizar: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return actualizarCompra();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: compra
                                                                      .fromMap(snapshot
                                                                              .data[
                                                                          index]),
                                                                ))).then(
                                                            (value) =>
                                                                setState(() {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarCompra();
                                  },
                                  settings: RouteSettings(
                                    arguments: un_dia!.Fecha,
                                  ))).then((value) => setState(() {}));
                        },
                        child: Text("Añadir +"),
                      ),
                    ])),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Accordion(
                    title: 'Ventas Particulares:',
                    content: Column(children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: FutureBuilder(
                            future: mdb.getOtrasVentasDia(mainText),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                                var s = double.parse(
                                        snapshot.data.length.toString()) *
                                    60;
                                return Row(children: <Widget>[
                                  Expanded(
                                      child: SizedBox(
                                          height: s,
                                          child: ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: itemOtraVenta(
                                                      una_venta: otraventa
                                                          .fromMap(snapshot
                                                              .data[index]),
                                                      tapBorrar: () async {
                                                        _eliminarOtraVenta(
                                                            otraventa.fromMap(
                                                                snapshot.data[
                                                                    index]));
                                                      },
                                                      tapActualizar: () async {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return actualizarOtraVenta();
                                                                },
                                                                settings:
                                                                    RouteSettings(
                                                                  arguments: venta
                                                                      .fromMap(snapshot
                                                                              .data[
                                                                          index]),
                                                                ))).then(
                                                            (value) =>
                                                                setState(() {
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return actualizarOtraVenta();
                                  },
                                  settings: RouteSettings(arguments: [
                                    mainText,
                                  ]))).then((value) => setState(() {}));
                        },
                        child: Text("Añadir +"),
                      ),
                    ])),
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                Accordion(
                    title: 'Registro de inventario',
                    content: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Stack(children: [
                          SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: FutureBuilder(
                                      future: mdb.getInventariosDia(mainText),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                              color: Colors.white,
                                              child:
                                                  const LinearProgressIndicator(
                                                      backgroundColor:
                                                          Colors.black));
                                        } else if (snapshot.hasError) {
                                          return Container(
                                              color: Colors.white,
                                              child: Center(
                                                  child: Text(
                                                      "Error de conexión",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6)));
                                        } else {
                                          var s = double.parse(
                                              snapshot.data.length.toString());

                                          if (s < 1) {
                                            return Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                        "No hay registro de inventario este dia!, ",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return inventarios();
                                                              },
                                                              settings:
                                                                  RouteSettings(
                                                                arguments:
                                                                    un_dia!,
                                                              ))).then(
                                                          (value) =>
                                                              setState(() {}));
                                                    },
                                                    child:
                                                        Text("Ver Inventario"),
                                                  ),
                                                )
                                              ],
                                            );
                                          } else {
                                            var s = double.parse(snapshot
                                                    .data.length
                                                    .toString()) *
                                                50;
                                            return Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 10),
                                                  child: Column(children: [
                                                    Row(children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                            "Un",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20),
                                                          )),
                                                      Expanded(
                                                          flex: 5,
                                                          child: Text(
                                                            "  Producto",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20),
                                                          )),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            "Pre(\$) ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20),
                                                          )),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            " Val(\$)",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 20),
                                                          )),
                                                    ])
                                                  ])),
                                              Row(children: <Widget>[
                                                Expanded(
                                                    child: SizedBox(
                                                        height: s,
                                                        child: ListView.builder(
                                                          itemBuilder:
                                                              (context, index) {
                                                            var p = inventario
                                                                .fromMap(snapshot
                                                                        .data[
                                                                    index]);

                                                            if (!prods
                                                                .contains(p)) {
                                                              prods.add(p);
                                                            }

                                                            return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.8),
                                                                child:
                                                                    itemInvantario(
                                                                        un_producto:
                                                                            p,
                                                                        tapBorrar:
                                                                            () async {
                                                                          _eliminarInventario();
                                                                        },
                                                                        tapActualizar:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (BuildContext context) {
                                                                                    return actualizarProducto();
                                                                                  },
                                                                                  settings: RouteSettings(
                                                                                    arguments: servicio.fromMap(snapshot.data[index]),
                                                                                  ))).then((value) => setState(() {
                                                                                value = value;
                                                                              }));
                                                                        }));
                                                          },
                                                          itemCount: snapshot
                                                              .data.length,
                                                        )))
                                              ]),
                                              ElevatedButton(
                                                onPressed: (() =>
                                                    _eliminarInventario()),
                                                child: Text("Descartar!"),
                                              ),
                                            ]);
                                          }
                                        }
                                      },
                                    )),
                              ]))
                        ]),
                      )
                    ])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text("Remesas",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getRemesasDia(mainText),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                                var s = double.parse(
                                    snapshot.data.length.toString());

                                if (s < 1) {
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              "No hay remesas en efectivo registradas este dia!, ",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return remesas();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: un_dia!,
                                                    ))).then(
                                                (value) => setState(() {}));
                                          },
                                          child: Text("+ Remesa en Efectivo"),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  String remesaTotal = "0";
                                  for (int i = 0; i < s; i++) {
                                    var r = remesa.fromMap(snapshot.data[i]);
                                    remesaTotal = (double.parse(remesaTotal) +
                                            double.parse(r.cantidad))
                                        .toString();
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 20),
                                          child: Text(
                                              "En efectivo: \$" + remesaTotal,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return remesas();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: un_dia!,
                                                    ))).then(
                                                (value) => setState(() {}));
                                          },
                                          child: Text("Ver Remesas +"),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }
                            },
                          )),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: FutureBuilder(
                            future: mdb.getRemesasDiaBTC(mainText),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                                var s = double.parse(
                                    snapshot.data.length.toString());

                                if (s < 1) {
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              "No hay remesas en BTC registradas este dia!, ",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return remesasBTC();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: un_dia!,
                                                    ))).then(
                                                (value) => setState(() {}));
                                          },
                                          child: Text("+ Remesa BTC"),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  String remesaTotal = "0";
                                  for (int i = 0; i < s; i++) {
                                    var r = remesaBTC.fromMap(snapshot.data[i]);
                                    remesaTotal = (double.parse(remesaTotal) +
                                            double.parse(r.cantidad))
                                        .toString();
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 20),
                                          child: Text(
                                              "En BTC: \$" + remesaTotal,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return remesasBTC();
                                                    },
                                                    settings: RouteSettings(
                                                      arguments: un_dia!,
                                                    ))).then(
                                                (value) => setState(() {}));
                                          },
                                          child: Text("Ver Remesas +"),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }
                            },
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: Text("Efectivo disponible: " + efe.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 40)),
              ])),
        ]));
  }

  _actualizar() async {
    var ds = mdb.getDias().then((value) {
      value.forEach((element) {
        if (dia.fromMap(element).Fecha == mainText) {
          un_dia = dia.fromMap(element);
          efe.text = un_dia!.efectivo_base;
          setState(() {});
        }
      });
    });
  }

  _eliminarbase(base una_base) async {
    showAlertDialogb(context, una_base);
  }

  showAlertDialogb(BuildContext context, base una_base) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.restarEfDia(una_base.fecha_dia, una_base.cantidad);
        await mdb.borrarBases(una_base.fecha_dia);
        _actualizar();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la base del " + una_base.fecha_dia + "?"),
      actions: [continueButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _eliminarInventario() async {
    showAlertDialogI(context);
  }

  showAlertDialogI(
    BuildContext context,
  ) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarInventario(mainText);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content:
          Text("Desea eliminar registro de inventario del " + mainText + "?"),
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

  _eliminarOtraVenta(otraventa una_venta) async {
    showAlertDialogV(context, una_venta);
  }

  showAlertDialogV(BuildContext context, otraventa una_venta) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.actualizarExProducto(una_venta.producto, una_venta.cantidad);
        await mdb.restarEfDia(una_venta.fecha_venta, una_venta.total);
        await mdb.borrarOtraVenta(una_venta);

        Navigator.of(context).pop(true);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la venta de " +
          una_venta.cantidad +
          " " +
          una_venta.producto +
          "?"),
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

  _eliminarCompra(compra una_compra) async {
    showAlertDialogC(context, una_compra);
  }

  showAlertDialogC(BuildContext context, compra una_compra) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.restarExProducto(una_compra.producto, una_compra.cantidad);
        await mdb.actualizarEfDia(una_compra.fecha_compra, una_compra.total);
        await mdb.borrarCompra(una_compra);
        Navigator.of(context).pop(true);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar la compra " +
          una_compra.fecha_compra +
          " | Prod:" +
          una_compra.producto +
          "?"),
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

  _eliminarGasto(gasto un_gasto) async {
    showAlertDialogG(context, un_gasto);
  }

  showAlertDialogG(BuildContext context, gasto un_gasto) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.actualizarEfDia(mainText, un_gasto.cantidad);
        await mdb.borrarGasto(un_gasto);
        Navigator.pop(context);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro del gasto de \$" +
          un_gasto.cantidad +
          " en " +
          un_gasto.tipo +
          "?"),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _eliminarAseo(aseo un_aseo) async {
    showAlertDialogA(context, un_aseo);
  }

  showAlertDialogA(BuildContext context, aseo un_aseo) {
    Widget continueButton = TextButton(
      child: Text("Borrar!"),
      onPressed: () async {
        await mdb.borrarAseo(un_aseo);
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Text("Desea eliminar el registro aseo " +
          un_aseo.habitacion +
          " a las " +
          un_aseo.inicio +
          "?"),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _eliminarServicio(servicio un_servicio) async {
    showAlertDialog(context, un_servicio);
    setState(() {});
  }

  showAlertDialog(BuildContext context, servicio un_servicio) {
    Widget continueButton = TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)))),
      child: Container(
          color: Colors.red,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("Eliminar!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)))),
      onPressed: () async {
        await mdb.borrarServicio(un_servicio);
        await mdb.borrarVentas(un_servicio.id_servicio.toString());
        await mdb.borrarCortesias(un_servicio.id_servicio.toString());
        await mdb.borrarServicio(un_servicio);
        setState(() {
          Navigator.pop(context);
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar?"),
      content: Container(
          height: 200,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
                child: Text("Desea eliminar el servicio Hora:" +
                    un_servicio.entrada +
                    " Habitacion:" +
                    un_servicio.habitacion.toString() +
                    " junto con toda su actividad permanentemente?")),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                child: Container(
                    color: HexColor(un_servicio.color_carro),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text("Transporte: " + un_servicio.transporte,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800))))),
          ])),
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
