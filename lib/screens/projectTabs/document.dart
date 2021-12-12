// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../project.dart';

class Document extends StatefulWidget {

  final email;
  final projectName;

  Document(this.email, this.projectName);

  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  final _auth = FirebaseAuth.instance;
  List todos = List.empty();
  String title = "";
  String description = "";
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
      floatingActionButton: _auth.currentUser!.email==widget.email? FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles();
          if (result == null) return;

          final file = result.files.first;

          final name = file.name.split('/').last;
          print(name);

          final newfile = await savefilepermanent(file);
          print("${file.path}");
          print("${newfile.path}");
          uplaod(newfile, name);
          openFile(file);
        },
        backgroundColor: kYellow,
        child: const Icon(Icons.add),
      ):null,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: kBoxDecoration,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MyTodos").doc(widget.projectName).collection('Document').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            QueryDocumentSnapshot<Object?>? documentSnapshot =
                                snapshot.data?.docs[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                elevation: 10,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  leading:
                                      textTofile(documentSnapshot!["ImageURL"]),
                                  title: Text((documentSnapshot != null)
                                      ? ((documentSnapshot["Name"] != null)
                                          ? documentSnapshot["Name"]
                                          : "")
                                      : ""),
                                  trailing: _auth.currentUser!.email==widget.email?IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      String id = documentSnapshot.id;
                                      setState(() {
                                        delete(id, documentSnapshot["Name"]);
                                      });
                                    },
                                  ):null,
                                  onTap: () async {
                                    await launch(documentSnapshot["ImageURL"]);
                                  },
                                ),
                              ),
                            );
                          }),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

  openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  uplaod(var file, var name) async {
    if (file != null) {
      var snapShot = await _storage.ref().child("$name").putFile(file);

      var downloadUrl = await snapShot.ref.getDownloadURL();
      print(downloadUrl);

      _firestore
          .collection("MyTodos").doc(widget.projectName).collection('Document')
          .add({"Name": name, "ImageURL": downloadUrl});
    } else {
      print("image is not uploaded in firebase");
    }
  }

  delete(itemid, itemname) {
    _storage.ref().child(itemname).delete();

    _firestore
        .collection("MyTodos").doc(widget.projectName).collection('Document')
        .doc(itemid)
        .delete()
        .whenComplete(() => print(itemname + "deleted successfully"));
  }

  savefilepermanent(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newfile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newfile.path);
  }

  textTofile(var text) {
    return Container(
        width: 40,
        child: Image.network(
          text,
          errorBuilder: (context, exception, stackTrace) {
            return Icon(Icons.file_copy);
          },
        ));
  }
}
