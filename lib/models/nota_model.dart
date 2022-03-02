import 'package:cloud_firestore/cloud_firestore.dart';

class NotaModel {
  String id;
  String titulo;
  String descripcion;
  Timestamp date;
  String userId;

  NotaModel(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.date,
      required this.userId});

  factory NotaModel.fromJson(DocumentSnapshot snapshot) {
    return NotaModel(
        id: snapshot.id,
        titulo: snapshot['titulo'],
        descripcion: snapshot['descripcion'],
        date: snapshot['date'],
        userId: snapshot['userId']);
  }
}
