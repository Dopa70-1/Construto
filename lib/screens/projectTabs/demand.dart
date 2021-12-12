// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../project.dart';

class Demand extends StatefulWidget {

  final email;
  final projectName;

  Demand(this.email, this.projectName);

  @override
  _DemandState createState() => _DemandState();
}

class _DemandState extends State<Demand> {
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
    FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Demand').doc();

    Map<String, String> todoList = {
      "DemandItem": title,
      "DemandDescription": description
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    print(item);
    DocumentReference documentReference =
      FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Demand').doc(item);

    documentReference
        .delete()
        .whenComplete(() => print("deleted successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
      floatingActionButton: _auth.currentUser!.email== widget.email? FloatingActionButton(
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
                                'Add Item',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kYellow,
                                  fontSize: 30.0,
                                ),
                              ),
                              TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (String value) {
                                  title = value;
                                },
                                textAlign: TextAlign.center,
                                cursorColor: Colors.redAccent,
                                decoration: const InputDecoration(
                                  hintText: 'Enter item name',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                ),
                              ),
                              TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onChanged: (String value) {
                                  description = value;
                                },
                                textAlign: TextAlign.center,
                                cursorColor: Colors.redAccent,
                                decoration: const InputDecoration(
                                  hintText: 'Enter item description',
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
      ):null,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: kBoxDecoration,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Demand').snapshots(),
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
                                elevation: 10,
                                child: ListTile(
                                  title: Text(
                                    (documentSnapshot != null)
                                        ? (documentSnapshot["DemandItem"])
                                        : "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text((documentSnapshot != null)
                                      ? ((documentSnapshot[
                                                  "DemandDescription"] !=
                                              null)
                                          ? documentSnapshot[
                                              "DemandDescription"]
                                          : "")
                                      : ""),
                                  trailing: _auth.currentUser!.email==widget.email? IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      String id = documentSnapshot!.id;
                                      print(id);
                                      setState(() {
                                        deleteTodo(id);
                                      });
                                    },
                                  ):null,
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
}
