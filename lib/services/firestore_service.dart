import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future agregarNota(String titulo, String descripcion, String userId) async {
    try {
      await firestore.collection('notas').add({
        'titulo': titulo,
        'descripcion': descripcion,
        'date': DateTime.now(),
        'userId': userId
      });
    } catch (e) {
      print(e);
    }
  }

  //
  // Editar Nota
  Future editarNota(String docId, String titulo, String descripcion) async {
    try {
      await firestore.collection('notas').doc(docId).update({
        'titulo': titulo,
        'descripcion': descripcion,
      });
    } catch (e) {
      print(e);
    }
  }

  //
  // Borrar Nota
  Future borrarNota(String docId) async {
    try {
      await firestore.collection('notas').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
