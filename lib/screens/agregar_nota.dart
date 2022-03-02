import 'package:fire_logins/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AgregarNota extends StatefulWidget {
  User user;
  AgregarNota(this.user);

  @override
  _AgregarNotaState createState() => _AgregarNotaState();
}

class _AgregarNotaState extends State<AgregarNota> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
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
                                  content: Text("No puede haber datos vacios"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                //
                                await FirestoreService().agregarNota(
                                    tituloController.text,
                                    descripcionController.text,
                                    widget.user.uid);
                                //
                                setState(() {
                                  loading = false;
                                });
                                //
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Guardar',
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
