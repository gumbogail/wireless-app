import 'package:flutter/material.dart';
import 'package:my_notes/database.dart';
import 'classnote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: NotesPage(),
    );
  }
}
