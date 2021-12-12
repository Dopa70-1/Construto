// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../project.dart';

class Trade extends StatefulWidget {

  final projectName;

  Trade(this.projectName);

  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  final _auth = FirebaseAuth.instance;
  List todos = List.empty();
  String title = "";
  String description = "";
  String price = "";

  @override
  void initState() {
    super.initState();
    todos = ["Hello", "Hey There"];
  }

  createToDo() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Trade').doc();

    Map<String, String> todoList = {
      "TradeItem": title,
      "TradeDescription": description,
      "TradePrice": "\u{20B9}" + " " + price + "/-",
      "Selected": 'false',
      "Rejected": 'false',
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  deleteTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Trade').doc(item);

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
                                'Add Details',
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
                                  hintText: 'About you',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: kYellow),
                                  ),
                                ),
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (String value) {
                                  price = value;
                                },
                                textAlign: TextAlign.center,
                                cursorColor: Colors.redAccent,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your price',
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: kBoxDecoration,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MyTodos").doc(widget.projectName).collection('Trade')
                    .orderBy("TradePrice", descending: true)
                    .snapshots(),
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
                                  leading: Container(
                                    alignment: AlignmentDirectional.centerStart,
                                    width: 100,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        (documentSnapshot != null)
                                            ? (documentSnapshot["TradePrice"])
                                            : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        // overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ),
                                  title: Text((documentSnapshot != null)
                                      ? (documentSnapshot["TradeItem"])
                                      : ""),
                                  subtitle: Text((documentSnapshot != null)
                                      ? ((documentSnapshot[
                                                  "TradeDescription"] !=
                                              null)
                                          ? documentSnapshot["TradeDescription"]
                                          : "")
                                      : ""),
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
