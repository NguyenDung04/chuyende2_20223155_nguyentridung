import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final CollectionReference notesRef =
  FirebaseFirestore.instance.collection('notes');

  Stream<List<NoteModel>> getNotes() {
    return notesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> addNote(String title, String content) async {
    await notesRef.add({
      'title': title,
      'content': content,
    });
  }

  Future<void> updateNote(String id, String title, String content) async {
    await notesRef.doc(id).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String id) async {
    await notesRef.doc(id).delete();
  }
}