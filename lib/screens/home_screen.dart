import 'package:fire_logins/models/nota_model.dart';
import 'package:fire_logins/screens/agregar_nota.dart';
import 'package:fire_logins/screens/editar_nota.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_logins/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatelessWidget {
  User user;
  HomeScreen(this.user);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        actions: [
          TextButton.icon(
            onPressed: () async {
              AuthService().signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Salir'),
            style: TextButton.styleFrom(primary: Colors.white),
          )
        ],
      ),
      //
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notas')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    NotaModel nota =
                        NotaModel.fromJson(snapshot.data.docs[index]);
                    return Card(
                      color: Colors.teal,
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        title: Text(
                          nota.titulo,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          nota.descripcion,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditarNota(nota)));
                        },
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text('No hay notas aun...'),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      /*ListView(
        children: [
          Card(
            color: Colors.teal,
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              title: Text(
                'Esta es mi Reg',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Una maravilla todo lo que se puede hacer con flutter hoy',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditarNota()));
              },
            ),
          )
        ],
      ),*/

      //
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AgregarNota(user)));
        },
      ),
    );
  }
}
