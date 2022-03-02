import 'package:fire_logins/models/nota_model.dart';
import 'package:fire_logins/services/firestore_service.dart';
import 'package:flutter/material.dart';

class EditarNota extends StatefulWidget {
  NotaModel nota;
  EditarNota(this.nota);

  @override
  _EditarNotaState createState() => _EditarNotaState();
}

class _EditarNotaState extends State<EditarNota> {
  //
  TextEditingController tituloController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  bool loading = false;
  //
  @override
  void initState() {
    tituloController.text = widget.nota.titulo;
    descripcionController.text = widget.nota.descripcion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmación'),
                        content: Text('Estas seguro de querer borra ?'),
                        actions: [
                          // boton SI
                          TextButton(
                              onPressed: () async {
                                await FirestoreService()
                                    .borrarNota(widget.nota.id);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Si')),
                          // boton NO
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Título',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                //
                SizedBox(height: 20),
                Text('Descripción',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                    controller: descripcionController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(border: OutlineInputBorder())),
                SizedBox(height: 30),
                loading
                    ? CircularProgressIndicator()
                    : Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.purpleAccent),
                            onPressed: () async {
                              if (tituloController.text == "" ||
                                  descripcionController == "") {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("¡ Se reguieren datos !"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                //
                                setState(() {
                                  loading = true;
                                });
                                //
                                await FirestoreService().editarNota(
                                    widget.nota.id,
                                    tituloController.text,
                                    descripcionController.text);
                                //
                                setState(() {
                                  loading = false;
                                });
                                //
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )),
                      ),
              ],
            )),
      ),
    );
  }
}
