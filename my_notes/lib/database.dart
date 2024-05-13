import 'package:flutter/material.dart';
import 'package:my_notes/databasehelper.dart';
//import 'database.dart';
import 'classnote.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    List<Note> notes = await DatabaseHelper.instance.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _addNote() async {
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      Note note = Note(
        title: title,
        content: content, id: 0,
      );
      await DatabaseHelper.instance.insertNote(note);
      _titleController.clear();
      _contentController.clear();
      _fetchNotes();
    }
  }

  void _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: Text('Add Note'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_notes[index].title),
                  subtitle: Text(_notes[index].content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(_notes[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
