// esta importacion produce error - import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SubirFoto extends StatefulWidget {
  //const SubirFoto({ Key? key }) : super(key: key);
  @override
  _SubirFotoState createState() => _SubirFotoState();
}

class _SubirFotoState extends State<SubirFoto> {
  //
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool cargando = false;

  // subir una imagen
  Future<void> subirImagen(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(
        source:
            inputSource == 'Cámara' ? ImageSource.camera : ImageSource.gallery);

    if (pickerImage == null) {
      return null;
    }
    String fileName = pickerImage.name;
    File imageFile = File(pickerImage.path);
    // Ahora vamos a comprimir la imagen octenida
    File comprimirArch = await comprimirImagen(imageFile);

    try {
      //
      setState(() {
        cargando = true;
      });
      //
      //await firebaseStorage.ref(fileName).putFile(imageFile);
      await firebaseStorage.ref(fileName).putFile(comprimirArch);
      //
      setState(() {
        cargando = false;
      });
      //
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("La foto se cargo satisfactoriamente"),
        backgroundColor: Colors.purple,
      ));
      //
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  //
  // octener todas las fotos
  Future<List> octenerImagen() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({"url": fileUrl, "path": file.fullPath});
    });
    print(files);
    return files;
  }

  //
  // borrar una foto
  Future<void> borrarImagen(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  //
  // comprimir una foto
  Future<File> comprimirImagen(File file) async {
    File comprimirArch =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print('Tamaño de la Original');
    print(file.lengthSync());
    print('Tamaño de la Comprimida');
    print(comprimirArch.lengthSync());
    return comprimirArch;
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir foto a Firebase Storage'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            cargando
                ? CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                          onPressed: (() {
                            subirImagen("Cámara");
                          }),
                          icon: Icon(Icons.camera),
                          label: Text('Cámara')),
                      //
                      ElevatedButton.icon(
                          onPressed: (() {
                            subirImagen("Galería");
                          }),
                          icon: Icon(Icons.library_add),
                          label: Text('Galería')),
                    ],
                  ),
            SizedBox(
              height: 50,
            ),
            Expanded(
                child: FutureBuilder(
                    future: octenerImagen(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length ?? 0,
                          itemBuilder: (context, index) {
                            final Map image = snapshot.data[index];
                            return Row(
                              children: [
                                Expanded(
                                    child: Card(
                                  child: Container(
                                    height: 200,
                                    child: CachedNetworkImage(
                                      imageUrl: image['url'],
                                      placeholder: (context, url) =>
                                          Image.asset('assets/cargando.gif'),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  /*child: Container(
                                    height: 200,
                                    child: Image.network(image['url']),
                                  ),*/
                                )),
                                IconButton(
                                    onPressed: () async {
                                      await borrarImagen(image['path']);
                                      //
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "La imagen ya fue borrada de Fibase Storage"),
                                        backgroundColor: Colors.red,
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            );
                          });
                    }))
          ],
        ),
      ),
    );
  }
}
