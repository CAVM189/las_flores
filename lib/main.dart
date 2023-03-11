import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:las_flores/UI/otros/empleados.dart';
import 'package:las_flores/UI/otros/habitaciones.dart';
//import 'package:las_flores/UI/otros/inventarios';
import 'package:las_flores/UI/otros/productos.dart';
import 'package:las_flores/bd/mongodb.dart';
import 'package:las_flores/UI/portada.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('lib/assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  await mdb.conectar();
  runApp(const MyApp());
}

var now = new DateTime.now();
var formatter = new DateFormat('yyyy-MM-dd');
String formattedDate = formatter.format(now);
// 2016-01-25

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hotel Las Flores',
        theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
          appBar: AppBar(title: Text("Hotel Las Flores"), actions: <Widget>[
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
          drawer: MenuLateral(),
          body: Center(
            child: portada(),
          ),
        ));
  }
}

_actualizar() async {
  State? s;
  s?.setState(() {});
}

class MenuLateral extends StatefulWidget {
  @override
  _MenuLateral createState() => _MenuLateral();
}

class _MenuLateral extends State<MenuLateral> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Ink(
              color: Colors.grey,
              child: new UserAccountsDrawerHeader(
                  accountName: Text("Personal, productos e instalaciones."),
                  accountEmail: Text("carlosvillaltatrabajo@gmail.com"),
                  decoration: BoxDecoration(color: Colors.red)
                  //image: //DecorationImage(
                  //image:
                  //NetworkImage("https://dominio.com/imagen/recurso.jpg"),
                  //fit: BoxFit.cover)),
                  )),
          new ListTile(
            title: Text("Habitaciones"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return habitaciones();
              })); //.then((value) => setState(() {}));
            },
          ),
          new ListTile(
            title: Text("Empleados"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return empleados();
              })); //.then((value) => setState(() {}));
            },
          ),
          new ListTile(
            title: Text("Productos"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return productos();
              })); //.then((value) => setState(() {}));
            },
          ),
          /*new ListTile(
            title: Text("Existencia"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return inventarios();
              })); //.then((value) => setState(() {}));
            },
          ),*/
        ],
      ),
    );
  }
}
