import 'package:flutter/material.dart';
import '../../controllers/note_controller.dart';
import '../../models/note_model.dart';
import '../../widgets/top_menu.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final NoteController controller = NoteController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void clearForm() {
    titleController.clear();
    contentController.clear();
  }

  Future<void> showNoteDialog({NoteModel? note}) async {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      clearForm();
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(note == null ? 'Thêm ghi chú' : 'Sửa ghi chú'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              if (title.isEmpty || content.isEmpty) return;

              if (note == null) {
                await controller.createNote(title, content);
              } else {
                await controller.editNote(note.id, title, content);
              }

              clearForm();
              if (mounted) Navigator.pop(context);
            },
            child: Text(note == null ? 'Thêm' : 'Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNoteDialog(),
        label: const Text('Thêm note'),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const TopMenu(currentIndex: 3),
            Expanded(
              child: StreamBuilder<List<NoteModel>>(
                stream: controller.getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data ?? [];

                  if (notes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notes.length,
                    itemBuilder: (_, index) {
                      final note = notes[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(18),
                          title: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(note.content),
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                onPressed: () => showNoteDialog(note: note),
                                icon: const Icon(Icons.edit, color: Colors.blue),
                              ),
                              IconButton(
                                onPressed: () => controller.removeNote(note.id),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}