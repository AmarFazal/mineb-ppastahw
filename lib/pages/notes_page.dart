import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../1frf_api.dart';
import '../config/config.dart';
import '../utilities/colors.dart';
import '../widgets/dialog.dart';

class Note {
  final String text;

  Note(this.text);
}

class NoteID {
  final String noteId;

  NoteID(this.noteId);
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  List<NoteID> notesId = [];
  TextEditingController newNoteController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotePage();
  }

  Future<void> _loadNotePage() async {
    int? agentId = await GetId.getAgentId();
    await sendTrue(agentId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> sendTrue(int? agentID) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': API_KEY,
      'Cookie': 'session=...'
    };

    var request = http.Request(
        'GET', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}get/profile/$agentID'));
    //request.body = json.encode({"loggedin": 'true', "agent_id": agentID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      setState(() {
        Map<String, dynamic> agentData =
            json.decode(responseString)['agent_data']['agent_notes'];
        notes = agentData.entries.map((entry) => Note(entry.value)).toList();
        notesId = agentData.entries.map((entry) => NoteID(entry.key)).toList();
      });
    } else {
      showErrorDialog(context, "Something Was Wrong. ${response.statusCode}");
    }
  }

  Future<void> newNote() async {
    int? agentId = await GetId.getAgentId();
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': 'alsdjfaioj'
    };

    // Text alanının içeriğini alın
    String newNoteText = newNoteController.text.trim(); // Boşlukları kaldırın

    if (newNoteText.isNotEmpty) {
      // Eğer metin alanı boş değilse devam edin
      var request = http.Request(
          'POST', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}post/note'));
      request.body =
          json.encode({"agent_id": agentId, "agent_note": newNoteText});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        setState(() {
          notes.add(Note(newNoteText));
        });
        newNoteController.clear();
        // Yeni not ekledikten sonra otomatik olarak yenile
        await _refreshData();
      } else {
        showErrorDialog(context, "Something Was Wrong. ${response.statusCode}");
      }
    } else {
      // Eğer text alanı boşsa kullanıcıya bir mesaj gösterin
      showErrorDialog(context, 'Please enter a note before adding.');
    }
  }

  void deleteNote(index) async {
    int? agentId = await GetId.getAgentId();
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': API_KEY,
      'Cookie': 'session=...'
    };

    var request = http.Request(
        'POST', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}delete/note'));
    request.body =
        json.encode({"note_id": notesId[index].noteId, "agent_id": agentId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // Notu yerel listeden kaldırın
      setState(() {
        notes.removeAt(index);
        notesId.removeAt(index);
      });
    } else {
      showErrorDialog(context, "Something Was Wrong. ${response.statusCode}");
    }
  }

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Note'),
          content: TextField(
            minLines: 3,
            maxLines: null,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(hintText: 'Type A Note...'),
            controller: newNoteController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                newNote();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _loadNotePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(
              color: CustomColors.accentColor,
              size: 50.0,
            ))
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: notes.isEmpty
                  ? const Center(
                      child: Text("You don't have any notes"),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(notes[index].text.trim()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteNote(index); // Silme işlemini başlat
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
