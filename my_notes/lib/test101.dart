import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Note {
  int id;
  String title;
  String body;

  Note({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}



class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final response = await http.get(Uri.parse('http://localhost/notes.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _notes = data.map((note) => Note.fromJson(note)).toList();
      });
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  Future<void> _saveNote() async {
    String title = _titleController.text.trim();
    String body = _bodyController.text.trim();
    if (title.isNotEmpty && body.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://192.168.1.41/php_scripts/CRUD.php'),
        body: {'title': title, 'body': body},
      );
      if (response.statusCode == 200) {
        _titleController.clear();
        _bodyController.clear();
        _fetchNotes(); // Refresh the list of notes after saving
      } else {
        throw Exception('Failed to save note');
      }
    }
  }

  Future<void> _deleteNote(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.41/CRUD.php'),
      body: {'id': id.toString()},
    );
    if (response.statusCode == 200) {
      _fetchNotes(); // Refresh the list of notes after deleting
    } else {
      throw Exception('Failed to delete note');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_notes[index].title),
                  subtitle: Text(_notes[index].body),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteNote(_notes[index].id);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: Text('Save Note'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
