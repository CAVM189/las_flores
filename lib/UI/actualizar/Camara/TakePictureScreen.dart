import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatefulWidget {
  @override
  State createState() {
    // TODO: implement createState
    return CameraWidgetState();
  }
}

class CameraWidgetState extends State {
  PickedFile? imageFile = null;
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Elija una opcion",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Galeria"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Tomar nueva foto"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Seleccione una Imagen"),
          backgroundColor: Colors.red,
          leading: BackButton(
            onPressed: () {
              try {
                Navigator.pop(context, imageFile!.path);
              } catch (e) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Column(children: [
            WillPopScope(
              onWillPop: () async {
                try {
                  Navigator.pop(context, imageFile!.path);
                  return true;
                } catch (e) {
                  Navigator.pop(context);
                  return false;
                }
              },
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: (imageFile == null)
                            ? Text("Elija una imagen")
                            : Image.file(File(imageFile!.path)),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                              child: MaterialButton(
                                textColor: Colors.white,
                                color: Colors.red,
                                onPressed: () {
                                  _showChoiceDialog(context);
                                },
                                child: Text("Buscar"),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 0, 20),
                                    child: MaterialButton(
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: () {
                                        try {
                                          Navigator.pop(
                                              context, imageFile!.path);
                                        } catch (e) {}
                                      },
                                      child: Text("Guardar"),
                                    ))),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 0, 20),
                                    child: MaterialButton(
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      onPressed: (() => eliminar()),
                                      child: Text("Eliminar"),
                                    )))
                          ]),
                    ],
                  ),
                ),
              ),
            )
          ]))
        ]));
  }

  void eliminar() {
    setState(() {
      try {
        imageFile = null;
      } catch (e) {}
    });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 200);
    setState(() {
      try {
        imageFile = pickedFile!;
      } catch (e) {}
    });

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 400);

    setState(() {
      try {
        imageFile = pickedFile!;
      } catch (e) {}
    });
    Navigator.pop(context);
  }
}
