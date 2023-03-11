import 'package:mongo_dart/mongo_dart.dart';

/*Dia*/
class dia {
  final int? id;
  final ObjectId id_dia;
  final String Fecha;
  final String inventario;
  final String efectivo_base;
  /* final String efectivo_btc;
  final String efectivo_compras;
  final String efectivo_gastos;
  final String efectivo_remesas;
  final String efectivo_servicios;
  final String efectivo_ventas;*/

  const dia({
    required this.id,
    required this.id_dia,
    required this.Fecha,
    required this.inventario,
    required this.efectivo_base,
    /*required this.efectivo_btc,
    required this.efectivo_compras,
    required this.efectivo_gastos,
    required this.efectivo_remesas,
    required this.efectivo_servicios,
    required this.efectivo_ventas,*/
  });

  Map<String, dynamic> toMap() {
    return {
      'id_sql': id,
      '_id': id_dia,
      'Fecha': Fecha,
      'inventario': inventario,
      'efectivo_base': efectivo_base,
      /*'efectivo_btc': efectivo_btc,
      'efectivo_compras': efectivo_compras,
      'efectivo_gastos': efectivo_gastos,
      'efectivo_remesas': efectivo_remesas,
      'efectivo_servicios': efectivo_servicios,
      'efectivo_ventas': efectivo_ventas*/
    };
  }

  dia.fromMap(Map<String, dynamic> map)
      : id = map['id_sql'],
        id_dia = map['_id'],
        Fecha = map['Fecha'],
        inventario = map['inventario'],
        efectivo_base = map['efectivo_base'];
  /* efectivo_btc = map['efectivo_btc'],
        efectivo_compras = map['efectivo_compras'],
        efectivo_gastos = map['efectivo_gastos'],
        efectivo_remesas = map['efectivo_remesas'],
        efectivo_servicios = map['efectivo_servicios'],
        efectivo_ventas = map['efectivo_ventas'];*/
}

/*Habitaciones*/
class habitacion {
  final ObjectId id_habitacion;
  final String numero;
  final String precio;

  const habitacion(
      {required this.id_habitacion,
      required this.numero,
      required this.precio});

  Map<String, dynamic> toMap() {
    return {'_id': id_habitacion, 'numero': numero, 'precio': precio};
  }

  habitacion.fromMap(Map<String, dynamic> map)
      : id_habitacion = map['_id'],
        numero = map['numero'],
        precio = map['precio'];
}

/*Transporte*/
class transporte {
  final ObjectId id_transporte;
  final String tipo;

  const transporte({required this.id_transporte, required this.tipo});

  Map<String, dynamic> toMap() {
    return {'_id': id_transporte, 'tipo': tipo};
  }

  transporte.fromMap(Map<String, dynamic> map)
      : id_transporte = map['_id'],
        tipo = map['tipo'];
}

/*Servicios*/
class servicio {
  final ObjectId id_servicio;
  final String fecha_dia;
  final String entrada;
  final String habitacion;
  final String salida;
  final String duracion;
  final String empleado;
  final String efectivo;
  final String btc;
  final String color_carro;
  final String placa_carro;
  final bool taxi_carro;
  final String nota;
  final String transporte;

  const servicio(
      {required this.id_servicio,
      required this.fecha_dia,
      required this.entrada,
      required this.habitacion,
      required this.salida,
      required this.duracion,
      required this.empleado,
      required this.efectivo,
      required this.btc,
      required this.color_carro,
      required this.placa_carro,
      required this.taxi_carro,
      required this.nota,
      required this.transporte});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_servicio,
      'fecha_dia': fecha_dia,
      'entrada': entrada,
      'habitacion': habitacion,
      'salida': salida,
      'duracion': duracion,
      'empleado': empleado,
      'efectivo': efectivo,
      'btc': btc,
      'color_carro': color_carro,
      'placa_carro': placa_carro,
      'taxi_carro': taxi_carro,
      'nota': nota,
      'transporte': transporte
    };
  }

  servicio.fromMap(Map<String, dynamic> map)
      : id_servicio = map['_id'],
        fecha_dia = map['fecha_dia'],
        entrada = map['entrada'],
        habitacion = map['habitacion'],
        salida = map['salida'],
        duracion = map['duracion'],
        empleado = map['empleado'],
        efectivo = map['efectivo'],
        btc = map['btc'],
        color_carro = map['color_carro'],
        placa_carro = map['placa_carro'],
        taxi_carro = map['taxi_carro'],
        nota = map['nota'],
        transporte = map['transporte'];
}

/*Aseos*/
class aseo {
  final ObjectId id_aseo;
  final String fecha_dia;
  final String inicio;
  final String fin;
  final String duracion;
  final String habitacion;
  final String empleado;
  final String notas;

  const aseo(
      {required this.id_aseo,
      required this.fecha_dia,
      required this.inicio,
      required this.fin,
      required this.duracion,
      required this.habitacion,
      required this.empleado,
      required this.notas});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_aseo,
      'fecha_dia': fecha_dia,
      'inicio': inicio,
      'fin': fin,
      'duracion': duracion,
      'habitacion': habitacion,
      'empleado': empleado,
      'notas': notas,
    };
  }

  aseo.fromMap(Map<String, dynamic> map)
      : id_aseo = map['_id'],
        fecha_dia = map['fecha_dia'],
        inicio = map['inicio'],
        fin = map['fin'],
        duracion = map['duracion'],
        habitacion = map['habitacion'],
        empleado = map['empleado'],
        notas = map['notas'];
}

/*Empleado*/
class empleado {
  final ObjectId id_empleado;
  final String nombre;
  final String DUI;

  const empleado(
      {required this.id_empleado, required this.nombre, required this.DUI});

  Map<String, dynamic> toMap() {
    return {'_id': id_empleado, 'nombre': nombre, 'DUI': DUI};
  }

  empleado.fromMap(Map<String, dynamic> map)
      : id_empleado = map['_id'],
        nombre = map['nombre'],
        DUI = map['DUI'];
}

/*Notas*/
class nota {
  final ObjectId id_nota;
  final String fecha_dia;
  final String detalle_nota;
  final String empleado;

  const nota(
      {required this.id_nota,
      required this.fecha_dia,
      required this.detalle_nota,
      required this.empleado});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_nota,
      'id_dia': fecha_dia,
      'detalle_nota': detalle_nota,
      'empleado': empleado
    };
  }

  nota.fromMap(Map<String, dynamic> map)
      : id_nota = map['_id'],
        fecha_dia = map['fecha_dia'],
        detalle_nota = map['detalle_nota'],
        empleado = map['empleado'];
}

/*Gasto*/
class gasto {
  final ObjectId id_gasto;
  final String fecha_dia;
  final String empleado;
  final String tipo;
  final String cantidad;
  final String hora;
  final String comprobante;

  const gasto(
      {required this.id_gasto,
      required this.fecha_dia,
      required this.empleado,
      required this.tipo,
      required this.cantidad,
      required this.hora,
      required this.comprobante});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_gasto,
      'fecha_dia': fecha_dia,
      'empleado': empleado,
      'tipo': tipo,
      'cantidad': cantidad,
      'hora': hora,
      'comprobante': comprobante
    };
  }

  gasto.fromMap(Map<String, dynamic> map)
      : id_gasto = map['_id'],
        fecha_dia = map['fecha_dia'],
        empleado = map['empleado'],
        tipo = map['tipo'],
        cantidad = map['cantidad'],
        hora = map['hora'],
        comprobante = map['comprobante'];
}

/*Remesas*/
class remesa {
  final ObjectId id_remesa;
  final String fecha_dia;
  final String cantidad;
  final String entrego;
  final String recibio;

  const remesa(
      {required this.id_remesa,
      required this.fecha_dia,
      required this.cantidad,
      required this.entrego,
      required this.recibio});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_remesa,
      'fecha_dia': fecha_dia,
      'cantidad': cantidad,
      'entrego': entrego,
      'recibio': recibio
    };
  }

  remesa.fromMap(Map<String, dynamic> map)
      : id_remesa = map['_id'],
        fecha_dia = map['fecha_dia'],
        cantidad = map['cantidad'],
        entrego = map['entrego'],
        recibio = map['recibio'];
}

/*Remesas*/
class remesaBTC {
  final ObjectId id_remesa;
  final String fecha_dia;
  final String cantidad;
  final String entrego;
  final String recibio;

  const remesaBTC(
      {required this.id_remesa,
      required this.fecha_dia,
      required this.cantidad,
      required this.entrego,
      required this.recibio});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_remesa,
      'fecha_dia': fecha_dia,
      'cantidad': cantidad,
      'entrego': entrego,
      'recibio': recibio
    };
  }

  remesaBTC.fromMap(Map<String, dynamic> map)
      : id_remesa = map['_id'],
        fecha_dia = map['fecha_dia'],
        cantidad = map['cantidad'],
        entrego = map['entrego'],
        recibio = map['recibio'];
}

/*Base*/
class base {
  final ObjectId id_base;
  final String fecha_dia;
  final String cantidad;
  final String entrego;
  final String recibio;

  const base(
      {required this.id_base,
      required this.fecha_dia,
      required this.cantidad,
      required this.entrego,
      required this.recibio});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_base,
      'fecha_dia': fecha_dia,
      'cantidad': cantidad,
      'entrego': entrego,
      'recibio': recibio
    };
  }

  base.fromMap(Map<String, dynamic> map)
      : id_base = map['_id'],
        fecha_dia = map['fecha_dia'],
        cantidad = map['cantidad'],
        entrego = map['entrego'],
        recibio = map['recibio'];
}

/*otrasVentas*/
class otraventa {
  final ObjectId id_otraventa;
  final String fecha_venta;
  final String producto;
  final String cantidad;
  final String precio;
  final String total;

  const otraventa(
      {required this.id_otraventa,
      required this.fecha_venta,
      required this.producto,
      required this.cantidad,
      required this.precio,
      required this.total});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_otraventa,
      'fecha_venta': fecha_venta,
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
      'total': total,
    };
  }

  otraventa.fromMap(Map<String, dynamic> map)
      : id_otraventa = map['_id'],
        fecha_venta = map['fecha_venta'],
        producto = map['producto'],
        cantidad = map['cantidad'],
        precio = map['precio'],
        total = map['total'];
}

/*Ventas*/
class venta {
  final ObjectId id_venta;
  final ObjectId id_servicio;
  final String fecha_venta;
  final String producto;
  final String cantidad;
  final String precio;
  final String total;

  const venta(
      {required this.id_venta,
      required this.id_servicio,
      required this.fecha_venta,
      required this.producto,
      required this.cantidad,
      required this.precio,
      required this.total});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_venta,
      'id_servicio': id_servicio,
      'fecha_venta': fecha_venta,
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
      'total': total,
    };
  }

  venta.fromMap(Map<String, dynamic> map)
      : id_venta = map['_id'],
        id_servicio = map['id_servicio'],
        fecha_venta = map['fecha_venta'],
        producto = map['producto'],
        cantidad = map['cantidad'],
        precio = map['precio'],
        total = map['total'];
}

/*Cortesias*/
class cortesia {
  final ObjectId id_cortesia;
  final ObjectId id_servicio;
  final String fecha_venta;
  final String cantidad;
  final String producto;

  const cortesia(
      {required this.id_cortesia,
      required this.id_servicio,
      required this.fecha_venta,
      required this.cantidad,
      required this.producto});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_cortesia,
      'id_servicio': id_servicio,
      'fecha_venta': fecha_venta,
      'cantidad': cantidad,
      'producto': producto,
    };
  }

  cortesia.fromMap(Map<String, dynamic> map)
      : id_cortesia = map['_id'],
        id_servicio = map['id_servicio'],
        fecha_venta = map['fecha_venta'],
        cantidad = map['cantidad'],
        producto = map['producto'];
}

/*Compra*/
class compra {
  final ObjectId id_compra;
  final String fecha_compra;
  final String producto;
  final String cantidad;
  final String precio;
  final String total;

  const compra(
      {required this.id_compra,
      required this.fecha_compra,
      required this.producto,
      required this.cantidad,
      required this.precio,
      required this.total});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_compra,
      'fecha_compra': fecha_compra,
      'producto': producto,
      'cantidad': cantidad,
      'precio': precio,
      'total': total
    };
  }

  compra.fromMap(Map<String, dynamic> map)
      : id_compra = map['_id'],
        fecha_compra = map['fecha_compra'],
        producto = map['producto'],
        cantidad = map['cantidad'],
        precio = map['precio'],
        total = map['total'];
}

/*inventario*/
class inventario {
  final ObjectId id_inventario;
  final String fecha_inventario;
  final String nombre_producto;
  final String cantidad;
  final String precio;
  final String valor;

  const inventario(
      {required this.id_inventario,
      required this.fecha_inventario,
      required this.nombre_producto,
      required this.cantidad,
      required this.precio,
      required this.valor});

  Map<String, dynamic> toMap() {
    return {
      '_id': id_inventario,
      'fecha_inventario': fecha_inventario,
      'nombre_producto': nombre_producto,
      'cantidad': cantidad,
      'precio': precio,
      'valor': valor
    };
  }

  inventario.fromMap(Map<String, dynamic> map)
      : id_inventario = map['_id'],
        fecha_inventario = map['fecha_inventario'],
        nombre_producto = map['nombre_producto'],
        cantidad = map['cantidad'],
        precio = map['precio'],
        valor = map['valor'];
}

/*Productos*/
class producto {
  final ObjectId id_producto;
  final String nombre;
  final String precio_venta;
  final String existencia;
  final String valor;

  const producto({
    required this.id_producto,
    required this.nombre,
    required this.precio_venta,
    required this.existencia,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id_producto,
      'nombre': nombre,
      'precio_venta': precio_venta,
      'existencia': existencia,
      'valor': valor
    };
  }

  producto.fromMap(Map<String, dynamic> map)
      : id_producto = map['_id'],
        nombre = map['nombre'],
        precio_venta = map['precio_venta'],
        existencia = map['existencia'],
        valor = map['valor'];
}
