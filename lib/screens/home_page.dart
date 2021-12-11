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

  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);

    Map<String, String> todoList = {
      "todoTitle": title,
      "todoDesc": description
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
              top: 60.0, bottom: 30.0, end: 30.0, start: 30.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        child: TextButton(
                          onPressed: () {
                            //Add drawer
                          },
                          child: const Icon(
                            Icons.supervised_user_circle_rounded,
                            size: 45.0,
                            color: kYellow,
                          ),
                        ),
                        radius: 30.0,
                        backgroundColor: Colors.blueGrey.shade900,
                      ),
                      const CircleAvatar(
                        child: Icon(
                          Icons.explore,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        radius: 20.0,
                        backgroundColor: Colors.teal,
                      ),
                    ]),
                const SizedBox(
                  height: 25.0,
                ),
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
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?>? documentSnapshot =
                            snapshot.data?.docs[index];
                        return Dismissible(
                            key: Key(index.toString()),
                            child: Card(
                              elevation: 4,
                              child: ListTile(
                                title: Text((documentSnapshot != null)
                                    ? (documentSnapshot["todoTitle"])
                                    : ""),
                                subtitle: Text((documentSnapshot != null)
                                    ? ((documentSnapshot["todoDesc"] != null)
                                        ? documentSnapshot["todoDesc"]
                                        : "")
                                    : ""),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      deleteTodo((documentSnapshot != null)
                                          ? (documentSnapshot["todoTitle"])
                                          : "");
                                    });
                                  },
                                ),
                              ),
                            ));
                      });
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
