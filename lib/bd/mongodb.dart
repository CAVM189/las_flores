import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:las_flores/UI/otros/habitaciones.dart';
import 'package:las_flores/main.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:las_flores/modelos/modelos.dart';
import 'package:las_flores/utiles/constantes.dart';

class mdb {
  static var bd,
      coleccionDias,
      coleccionHabitaciones,
      coleccionCortesias,
      coleccionEmpleados,
      coleccionTransportes,
      coleccionVentas,
      coleccionOtrasVentas,
      coleccionCompras,
      coleccionServicios,
      coleccionAseos,
      coleccionNotas,
      coleccionGastos,
      coleccionRemesas,
      coleccionRemesasBTC,
      coleccionBases,
      coleccionInventarios,
      coleccionProductos;

  static conectar() async {
    bd = await Db.create(conexion);
    await bd.close();
    await bd.open();
    try {
      coleccionDias = bd.collection(coleccionDi);
      coleccionHabitaciones = bd.collection(coleccionHab);
      coleccionCortesias = bd.collection(coleccionCort);
      coleccionEmpleados = bd.collection(coleccionEmp);
      coleccionTransportes = bd.collection(coleccionTrans);
      coleccionVentas = bd.collection(coleccionVent);
      coleccionOtrasVentas = bd.collection(coleccionOtrasVent);
      coleccionCompras = bd.collection(coleccionComp);
      coleccionServicios = bd.collection(coleccionServ);
      coleccionAseos = bd.collection(coleccionAse);
      coleccionNotas = bd.collection(coleccionNot);
      coleccionGastos = bd.collection(coleccionGas);
      coleccionRemesas = bd.collection(coleccionRem);
      coleccionRemesasBTC = bd.collection(coleccionRemBTC);
      coleccionBases = bd.collection(coleccionBas);
      coleccionInventarios = bd.collection(coleccionInv);
      coleccionProductos = bd.collection(coleccionProd);
    } catch (e) {
      conectar();
    }
  }

  static Future<List<Map<String, dynamic>>> getDias() async {
    try {
      final dias = await coleccionDias.find().toList();
      return dias;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static actualizarEfDia(String fecha, String cantidad) async {
    var j = await coleccionDias.findOne({'Fecha': fecha});

    try {
      var cant = (double.parse(cantidad) + double.parse(j["efectivo_base"]))
          .toString();
      j["efectivo_base"] = cant;
      await coleccionDias.save(j);
    } catch (e) {
      conectar();
    }
  }

  static restarEfDia(String fecha, String cantidad) async {
    var j = await coleccionDias.findOne({'Fecha': fecha});

    try {
      var cant = (double.parse(j["efectivo_base"]) - (double.parse(cantidad)))
          .toString();
      j["efectivo_base"] = cant;
      await coleccionDias.save(j);
    } catch (e) {
      conectar();
    }
  }

  static insertarDia(dia un_dia) async {
    await coleccionDias.insertAll([un_dia.toMap()]);
  }

  static actualizarDia(dia un_dia) async {
    var j = await coleccionDias.findOne({'_id': un_dia.id_dia});
    j["Fecha"] = un_dia.Fecha;
    await coleccionDias.save(j);
  }

  static borrarDia(dia un_dia) async {
    await coleccionDias.remove(where.id(un_dia.id_dia));
  }

/*Habitacion*/
  static Future<List<Map<String, dynamic>>> getHabitaciones() async {
    try {
      final habitaciones = await coleccionHabitaciones.find().toList();
      return habitaciones;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarHabitacion(habitacion una_habitacion) async {
    await coleccionHabitaciones.insertAll([una_habitacion.toMap()]);
  }

  static actualizarHabitacion(habitacion una_habitacion) async {
    var j = await coleccionDias.findOne({'_id': una_habitacion.id_habitacion});
    j["numero"] = una_habitacion.numero;
    j["precio"] = una_habitacion.precio;
    await coleccionHabitaciones.save(j);
  }

  static borrarHabitacion(habitacion una_habitacion) async {
    await coleccionHabitaciones.remove(where.id(una_habitacion.id_habitacion));
  }

  /*Empleados*/
  static Future<List<Map<String, dynamic>>> getEmpleados() async {
    try {
      final empleados = await coleccionEmpleados.find().toList();
      return empleados;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  /* static List<String> getEmpleadosList() {
    List<String> l = [];
    var s = FutureBuilder(
        future: mdb.getEmpleados(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(color: Colors.white, child: Text(""));
          } else if (snapshot.hasError) {
            return Container(color: Colors.white, child: Text(""));
          } else {}
          return Scaffold(
              appBar: AppBar(title: Text("Empleados")), //title
              body: ListView.builder(itemBuilder: (context, index) {
                l.add(empleado.fromMap(snapshot.data[index]).nombre);
                return Text("data");
              }));
        });

    return l;
  }*/

  static insertarEmpleado(empleado un_empleado) async {
    await coleccionEmpleados.insertAll([un_empleado.toMap()]);
  }

  static actualizarEmpleado(empleado un_empleado) async {
    var j = await coleccionEmpleados.findOne({'_id': un_empleado.id_empleado});
    j["nombre"] = un_empleado.nombre;
    j["DUI"] = un_empleado.DUI;
    await coleccionEmpleados.save(j);
  }

  static borrarEmpleado(empleado una_empleado) async {
    await coleccionEmpleados.remove(where.id(una_empleado.id_empleado));
  }

  /*Transporte*/
  static Future<List<Map<String, dynamic>>> getTransporte() async {
    try {
      final transportes = await coleccionTransportes.find().toList();
      return transportes;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarTransporte(transporte un_transporte) async {
    await coleccionTransportes.insertAll([un_transporte.toMap()]);
  }

  static actualizarTransporte(transporte un_transporte) async {
    var j = await coleccionTransportes
        .findOne({'_id': un_transporte.id_transporte});
    j["tipo"] = un_transporte.tipo;
    await coleccionTransportes.save(j);
  }

  static borrarTransporte(transporte un_transporte) async {
    await coleccionTransportes.remove(where.id(un_transporte.id_transporte));
  }

/*Ventas*/
  static Future<List<Map<String, dynamic>>> getVentas() async {
    try {
      final ventas = await coleccionVentas.find().toList();
      return ventas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getVentasDia(
      ObjectId id_servicio) async {
    try {
      final ventas = await coleccionVentas
          .find(where
              .eq("id_servicio", id_servicio)
              .sortBy('$DateTime(fecha_venta)'))
          .toList();
      return ventas;
    } catch (e) {
      print(e);
      return await Future.value();
    }
  }

  static insertarVenta(venta una_venta) async {
    await coleccionVentas.insertAll([una_venta.toMap()]);
  }

  static actualizarVenta(venta una_venta) async {
    var j = await coleccionVentas.findOne({'_id': una_venta.id_venta});
    j["fecha_venta"] = una_venta.fecha_venta;
    j["id_servicio"] = una_venta.id_servicio;
    j["producto"] = una_venta.producto;
    j["cantidad"] = una_venta.cantidad;
    j["precio"] = una_venta.precio;
    j["total"] = una_venta.total;
    await coleccionVentas.save(j);
  }

  static borrarVentas(String id_servicio) async {
    await coleccionVentas.remove(where.eq("id_servicio", id_servicio));
  }

  static borrarVenta(venta una_venta) async {
    await coleccionVentas.remove(where.id(una_venta.id_venta));
  }

/*OtrasVentas*/
  static Future<List<Map<String, dynamic>>> getOtrasVentas() async {
    try {
      final ventas = await coleccionVentas.find().toList();
      return ventas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getOtrasVentasDia(
      String fecha) async {
    try {
      final otras_ventas = await coleccionOtrasVentas
          .find(where.eq("fecha_venta", fecha).sortBy('$DateTime(fecha_venta)'))
          .toList();
      return otras_ventas;
    } catch (e) {
      print(e);
      return await Future.value();
    }
  }

  static insertarOtraVenta(otraventa otra_venta) async {
    await coleccionOtrasVentas.insertAll([otra_venta.toMap()]);
  }

  static actualizarOtraVenta(otraventa otra_venta) async {
    var j =
        await coleccionOtrasVentas.findOne({'_id': otra_venta.id_otraventa});
    j["fecha_venta"] = otra_venta.fecha_venta;
    j["producto"] = otra_venta.producto;
    j["cantidad"] = otra_venta.cantidad;
    j["precio"] = otra_venta.precio;
    j["total"] = otra_venta.total;
    await coleccionOtrasVentas.save(j);
  }

  static borrarOtraVenta(otraventa otra_venta) async {
    await coleccionOtrasVentas.remove(where.id(otra_venta.id_otraventa));
  }

/*Compras*/
  static Future<List<Map<String, dynamic>>> getCompras() async {
    try {
      final compras = await coleccionCompras.find().toList();
      return compras;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getComprasDia(String fecha) async {
    try {
      final compras =
          await coleccionCompras.find(where.eq("fecha_compra", fecha)).toList();
      return compras;
    } catch (e) {
      print(e);
      return await Future.value();
    }
  }

  static insertarCompra(compra una_compra) async {
    await coleccionCompras.insertAll([una_compra.toMap()]);
  }

  static actualizarCompra(compra una_compra) async {
    var j = await coleccionCompras.findOne({'_id': una_compra.id_compra});
    j["fecha_compra"] = una_compra.fecha_compra;
    j["producto"] = una_compra.producto;
    j["cantidad"] = una_compra.cantidad;
    j["precio"] = una_compra.precio;
    j["total"] = una_compra.total;
    await coleccionCompras.save(j);
  }

  static borrarCompra(compra una_compra) async {
    await coleccionCompras.remove(where.id(una_compra.id_compra));
  }

/*Cortesias*/
  static Future<List<Map<String, dynamic>>> getCortesias() async {
    try {
      final cortesias = await coleccionCortesias.find().toList();
      return cortesias;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getCortesiasServicio(
      ObjectId id_servicio) async {
    try {
      final cortesias = await coleccionCortesias
          .find(where
              .eq("id_servicio", id_servicio)
              .sortBy('$DateTime(fecha_venta)'))
          .toList();
      return cortesias;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getCortesiasDia(
      String fecha) async {
    try {
      final cortesias = await coleccionCortesias
          .find(where.eq("fecha_venta", fecha).sortBy('$DateTime(fecha_venta)'))
          .toList();
      return cortesias;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarCortesia(cortesia una_cortesia) async {
    await coleccionCortesias.insertAll([una_cortesia.toMap()]);
  }

  static actualizarCortesia(cortesia una_cortesia) async {
    var j = await coleccionCortesias.findOne({'_id': una_cortesia.id_cortesia});
    j["id_servicio"] = una_cortesia.id_servicio;
    j["producto"] = una_cortesia.producto;
    j["cantidad"] = una_cortesia.cantidad;
    await coleccionCortesias.save(j);
  }

  static borrarCortesias(String id_servicio) async {
    await coleccionVentas.remove(where.eq("id_servicio", id_servicio));
  }

  static borrarCortesia(cortesia una_cortesia) async {
    await coleccionCortesias.remove(where.id(una_cortesia.id_cortesia));
  }

  /*Servicios*/
  static Future<List<Map<String, dynamic>>> getServiciosdelDia(
      String fecha_dia) async {
    try {
      final servicios = await coleccionServicios
          .find(where.eq("fecha_dia", fecha_dia).sortBy('$DateTime(fecha_dia)'))
          .toList();
      return servicios;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getServicios() async {
    try {
      final servicios = await coleccionServicios.find().toList();
      return servicios;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarServicio(servicio un_servicio) async {
    await coleccionServicios.insertAll([un_servicio.toMap()]);
  }

  static actualizarServicio(servicio un_servicio) async {
    var j = await coleccionServicios.findOne({'_id': un_servicio.id_servicio});
    j["fecha_dia"] = un_servicio.fecha_dia;
    j["transporte"] = un_servicio.transporte;
    j["btc"] = un_servicio.btc;
    j["color_carro"] = un_servicio.color_carro;
    j["duracion"] = un_servicio.duracion;
    j["efectivo"] = un_servicio.efectivo;
    j["empleado"] = un_servicio.empleado;
    j["entrada"] = un_servicio.entrada;
    j["nota"] = un_servicio.nota;
    j["placa_carro"] = un_servicio.placa_carro;
    j["salida"] = un_servicio.salida;
    await coleccionServicios.save(j);
  }

  static borrarServicio(servicio un_servicio) async {
    await coleccionServicios.remove(where.id(un_servicio.id_servicio));
    await coleccionVentas
        .remove(where.eq("id_servicio", un_servicio.id_servicio));
    await coleccionCortesias
        .remove(where.eq("id_servicio", un_servicio.id_servicio));
  }

/*Aseos*/
  static Future<List<Map<String, dynamic>>> getAseos() async {
    try {
      final aseos = await coleccionAseos.find().toList();
      return aseos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getAseosdelDia(
      String fecha_dia) async {
    try {
      final aseos = await coleccionAseos
          .find(where.eq("fecha_dia", fecha_dia).sortBy('$DateTime(fecha_dia)'))
          .toList();
      return aseos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarAseo(aseo un_aseo) async {
    await coleccionAseos.insertAll([un_aseo.toMap()]);
  }

  static actualizarAseo(aseo un_aseo) async {
    var j = await coleccionAseos.findOne({'_id': un_aseo.id_aseo});
    j["fecha_dia"] = un_aseo.fecha_dia;
    j["inicio"] = un_aseo.inicio;
    j["fin"] = un_aseo.fin;
    j["duracion"] = un_aseo.duracion;
    j["habitacion"] = un_aseo.habitacion;
    j["empleado"] = un_aseo.empleado;
    j["notas"] = un_aseo.notas;
    await coleccionAseos.save(j);
  }

  static borrarAseo(aseo un_aseo) async {
    await coleccionAseos.remove(where.id(un_aseo.id_aseo));
  }

  /*Notas*/
  static Future<List<Map<String, dynamic>>> getNotas() async {
    try {
      final notas = await coleccionNotas.find().toList();
      return notas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarNota(nota una_nota) async {
    await coleccionNotas.insertAll([una_nota.toMap()]);
  }

  static actualizarNota(nota una_nota) async {
    var j = await coleccionNotas.findOne({'_id': una_nota.id_nota});
    j["fecha_dia"] = una_nota.fecha_dia;
    j["empleado"] = una_nota.empleado;
    j["detalle_nota"] = una_nota.detalle_nota;
    await coleccionNotas.save(j);
  }

  static borrarNota(nota una_nota) async {
    await coleccionNotas.remove(where.id(una_nota.id_nota));
  }

  /*Gastos*/
  static Future<List<Map<String, dynamic>>> getGastos() async {
    try {
      final gastos = await coleccionGastos.find().toList();
      return gastos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getGastosdelDia(
      String fecha_dia) async {
    try {
      final gastos = await coleccionGastos
          .find(where.eq("fecha_dia", fecha_dia).sortBy('$DateTime(fecha_dia)'))
          .toList();
      return gastos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarGasto(gasto un_gasto) async {
    await coleccionGastos.insertAll([un_gasto.toMap()]);
  }

  static actualizarGasto(gasto un_gasto) async {
    var j = await coleccionGastos.findOne({'_id': un_gasto.id_gasto});
    j["fecha_dia"] = un_gasto.fecha_dia;
    j["cantidad"] = un_gasto.cantidad;
    j["comprobante"] = un_gasto.comprobante;
    j["empleado"] = un_gasto.empleado;
    j["tipo"] = un_gasto.tipo;
    j["hora"] = un_gasto.hora;
    await coleccionGastos.save(j);
  }

  static borrarGasto(gasto un_gasto) async {
    await coleccionGastos.remove(where.id(un_gasto.id_gasto));
  }

/*Remesas*/
  static Future<List<Map<String, dynamic>>> getRemesas() async {
    try {
      final remesas = await coleccionRemesas.find().toList();
      return remesas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getRemesasDia(String fecha) async {
    try {
      final remesas =
          await coleccionRemesas.find(where.eq("fecha_dia", fecha)).toList();
      return remesas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarRemesa(remesa una_remesa) async {
    await coleccionRemesas.insertAll([una_remesa.toMap()]);
  }

  static actualizarRemesa(remesa una_remesa) async {
    var j = await coleccionRemesas.findOne({'_id': una_remesa.id_remesa});
    j["fecha_dia"] = una_remesa.fecha_dia;
    j["cantidad"] = una_remesa.cantidad;
    j["entrego"] = una_remesa.entrego;
    j["recibio"] = una_remesa.recibio;
    await coleccionRemesas.save(j);
  }

  static borrarRemesa(remesa una_remesa) async {
    await coleccionRemesas.remove(where.id(una_remesa.id_remesa));
  }

  /*Remesas*/
  static Future<List<Map<String, dynamic>>> getRemesasBTC() async {
    try {
      final remesas = await coleccionRemesasBTC.find().toList();
      return remesas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getRemesasDiaBTC(
      String fecha) async {
    try {
      final remesas =
          await coleccionRemesasBTC.find(where.eq("fecha_dia", fecha)).toList();
      return remesas;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarRemesaBTC(remesaBTC una_remesa) async {
    await coleccionRemesasBTC.insertAll([una_remesa.toMap()]);
  }

  static actualizarRemesaBTC(remesaBTC una_remesa) async {
    var j = await coleccionRemesasBTC.findOne({'_id': una_remesa.id_remesa});
    j["fecha_dia"] = una_remesa.fecha_dia;
    j["cantidad"] = una_remesa.cantidad;
    j["entrego"] = una_remesa.entrego;
    j["recibio"] = una_remesa.recibio;
    await coleccionRemesasBTC.save(j);
  }

  static borrarRemesaBTC(remesaBTC una_remesa) async {
    await coleccionRemesasBTC.remove(where.id(una_remesa.id_remesa));
  }

  /*Bases*/
  static Future<List<Map<String, dynamic>>> getBases() async {
    try {
      final bases = await coleccionBases.find().toList();
      return bases;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getBaseDelDia(String fecha) async {
    try {
      final bases =
          await coleccionBases.find(where.eq("fecha_dia", fecha)).toList();
      return bases;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarBase(base una_base) async {
    await coleccionBases.insertAll([una_base.toMap()]);
    return true;
  }

  static actualizarBase(base una_base) async {
    var j = await coleccionBases.findOne({'_id': una_base.id_base});
    j["fecha_dia"] = una_base.fecha_dia;
    j["cantidad"] = una_base.cantidad;
    j["entrego"] = una_base.entrego;
    j["recibio"] = una_base.recibio;
    await coleccionBases.save(j);
  }

  static borrarBases(String fecha) async {
    await coleccionBases.remove(where.eq("fecha_dia", fecha));
  }

  static borrarBase(base una_base) async {
    await coleccionBases.remove(where.id(una_base.id_base));
  }

  /*Inventario*/
  static Future<List<Map<String, dynamic>>> getInventariosDia(
      String fecha) async {
    try {
      final inventarios = await coleccionInventarios
          .find(where.eq("fecha_inventario", fecha))
          .toList();
      return inventarios;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarInventario(inventario un_inventario) async {
    await coleccionInventarios.insertAll([un_inventario.toMap()]);
  }

  /*static actualizarInventario(inventario un_inventario) async {
    var j = await coleccionInventarios
        .findOne({'_id': un_inventario.id_inventario});
    j["camara"] = un_inventario.camara;
    j["precio"] = un_inventario.precio;
    j["reserva"] = un_inventario.reserva;
    j["total"] = un_inventario.total;
    await coleccionInventarios.save(j);
  }*/

  static borrarInventario(String un_inventario) async {
    await coleccionInventarios.remove({});
  }

  /*Productos*/
  static Future<List<Map<String, dynamic>>> getProductosExistentes() async {
    try {
      List<String> l = [];
      l.add("0");
      final productos =
          await coleccionProductos.find(where.nin("existencia", l)).toList();
      return productos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static Future<List<Map<String, dynamic>>> getProductos() async {
    try {
      final productos = await coleccionProductos.find().toList();
      return productos;
    } catch (e) {
      conectar();
      print(e);
      return await Future.value();
    }
  }

  static insertarProducto(producto un_producto) async {
    await coleccionProductos.insertAll([un_producto.toMap()]);
  }

  static actualizarProducto(producto un_producto) async {
    var j = await coleccionProductos.findOne({'_id': un_producto.id_producto});
    j["nombre"] = un_producto.nombre;
    j["precio_venta"] = un_producto.precio_venta;
    j["existencia"] = un_producto.existencia;
    j["valor"] = un_producto.valor;
    await coleccionProductos.save(j);
  }

  static actualizarExProducto(String producto, String existencia) async {
    var j = await coleccionProductos.findOne({'nombre': producto});

    try {
      existencia =
          (int.parse(existencia) + int.parse(j["existencia"])).toString();
      j["existencia"] = existencia;
      await coleccionProductos.save(j);
    } catch (e) {
      conectar();
    }
  }

  static restarExProducto(String producto, String existencia) async {
    var j = await coleccionProductos.findOne({'nombre': producto});

    try {
      var ex = int.parse(j["existencia"]);
      var sal = int.parse(existencia);
      if (ex >= sal) {
        existencia = (ex - sal).toString();
        j["existencia"] = existencia;
        await coleccionProductos.save(j);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static borrarProducto(producto un_producto) async {
    await coleccionProductos.remove(where.id(un_producto.id_producto));
  }
}
