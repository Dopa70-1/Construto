// ignore_for_file: prefer_const_constructors

import 'package:construto/screens/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  List todos = List.empty();
  String title = "";
  String description = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
    email = _auth.currentUser!.email!;
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "projectName": title,
      "projectTitle": description,
      "email": email
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: kYellow,
        elevation: 0,
      ),
      drawer: Drawer(),
      backgroundColor: kYellow,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: const Color(0xff757575),
                      child: Container(
                        decoration: kBoxDecoration,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Add Project',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kYellow,
                                  fontSize: 30.0,
                                ),
                              ),
                              TextField(
                                onChanged: (String value) {
                                  title = value;
                                },
                                textAlign: TextAlign.center,
                                cursorColor: Colors.redAccent,
                                decoration: const InputDecoration(
                                  hintText: 'Enter project name',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (String value) {
                                  description = value;
                                },
                                textAlign: TextAlign.center,
                                cursorColor: Colors.redAccent,
                                decoration: const InputDecoration(
                                  hintText: 'Enter project description',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    //todos.add(title);
                                    createToDo();
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0),
                                    )),
                                style: TextButton.styleFrom(
                                  backgroundColor: kYellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))),
          );
        },
        backgroundColor: kYellow,
        child: const Icon(Icons.add),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsetsDirectional.only(
              top: 0.0, bottom: 30.0, end: 30.0, start: 30.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${_auth.currentUser!.displayName}',
                  style: GoogleFonts.dancingScript(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 40.0,
                  )),
                ),
                const Text(
                  'Which project are you working on today?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ]),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: kBoxDecoration,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("MyTodos").snapshots(),
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
                              child: ListTileTheme(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                tileColor: documentSnapshot!["email"]==email ? kYellow: Colors.white,
                                child: ListTile(
                                  title: Text((documentSnapshot != null)
                                      ? (documentSnapshot["projectName"])
                                      : "",),
                                  subtitle: Text((documentSnapshot != null)
                                      ? ((documentSnapshot["projectTitle"] !=
                                              null)
                                          ? documentSnapshot["projectTitle"]
                                          : "")
                                      : "",
                                  ),
                                  trailing: documentSnapshot["email"]==email?IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        deleteTodo((documentSnapshot != null)
                                            ? (documentSnapshot["projectName"])
                                            : "");
                                      });
                                    },
                                  ):null,
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Project(documentSnapshot["email"], documentSnapshot["projectName"]);
                                    }));
                                  },
                                ),
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
      ]),
    );
  }
}
