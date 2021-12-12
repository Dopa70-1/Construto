// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../project.dart';

class Team extends StatefulWidget {

  final projectName;

  Team(this.projectName);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
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
                                  trailing: Container(
                                    width: 100,
                                    child: documentSnapshot!["Selected"]=='false' && documentSnapshot["Rejected"] == 'false'?Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check),
                                          color: Colors.green,
                                          onPressed: () {
                                            var collection = FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Trade');
                                            collection
                                                .doc(documentSnapshot.id) // <-- Doc ID where data should be updated.
                                                .update({'Selected' : 'true'});
                                          },
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.cancel_outlined),
                                          color: Colors.red,
                                          onPressed: () {
                                            var collection = FirebaseFirestore.instance.collection("MyTodos").doc(widget.projectName).collection('Trade');
                                            collection
                                                .doc(documentSnapshot.id) // <-- Doc ID where data should be updated.
                                                .update({'Rejected' : 'true'});
                                          },
                                        ),
                                      ],
                                    ):
                                    documentSnapshot["Selected"] == 'true' && documentSnapshot["Rejected"] == 'false'?
                                    Text(
                                        'Selected',
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ):
                                    Text(
                                        'Rejected',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
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
        ),
      ]),
    );
  }
}
