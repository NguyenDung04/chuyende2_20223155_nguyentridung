import '../services/firestore_service.dart';
import '../models/note_model.dart';

class NoteController {
  final FirestoreService _service = FirestoreService();

  Stream<List<NoteModel>> getNotes() => _service.getNotes();

  Future<void> createNote(String title, String content) {
    return _service.addNote(title, content);
  }

  Future<void> editNote(String id, String title, String content) {
    return _service.updateNote(id, title, content);
  }

  Future<void> removeNote(String id) {
    return _service.deleteNote(id);
  }
}