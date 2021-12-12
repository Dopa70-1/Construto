// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:construto/constants.dart';
import 'package:construto/screens/projectTabs/demand.dart';
import 'package:construto/screens/projectTabs/document.dart';
import 'package:construto/screens/projectTabs/team.dart';
import 'package:construto/screens/projectTabs/trade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Project extends StatefulWidget {

  final String email;
  final String projectName;

  Project(this.email, this.projectName);

  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final _auth = FirebaseAuth.instance;
  late final tabBarView;
  late final tablist;

  @override
  void initState() {
    super.initState();
    getTab();
    getTabList();
  }

  void getTabList(){
    if(widget.email==_auth.currentUser!.email){
      tabBarView = TabBarView(children: [
        Demand(widget.email, widget.projectName),
        Document(widget.email, widget.projectName),
        Team(widget.projectName),
        Demand(widget.email, widget.projectName),
      ]);
    }
    else{
      tabBarView = TabBarView(children: [
        Trade(widget.projectName),
        Demand(widget.email, widget.projectName),
        Document(widget.email, widget.projectName),
        Demand(widget.email, widget.projectName),
      ]);
    }
  }

  void getTab(){
    if(widget.email==_auth.currentUser!.email){
      tablist = [
        Tab(
          icon: Icon(Icons.list_alt_outlined),
          text: "Demand",
        ),
        Tab(
          icon: Icon(Icons.file_copy_outlined),
          text: "Documentation",
        ),
        Tab(
          icon: Icon(Icons.people_alt_outlined),
          text: "Teams",
        ),
        Tab(
          icon: Icon(Icons.error),
          text: "Rules",
        ),
      ];
    }
    else{
      tablist = [
        Tab(
          icon: Icon(Icons.attach_money_outlined),
          text: "Trade",
        ),
        Tab(
          icon: Icon(Icons.list_alt_outlined),
          text: "Demand",
        ),
        Tab(
          icon: Icon(Icons.file_copy_outlined),
          text: "Documentation",
        ),
        Tab(
          icon: Icon(Icons.error),
          text: "Rules",
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: kYellow,
          backgroundColor: kYellow,
          automaticallyImplyLeading: false,
          title: Text(
            widget.projectName,
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelColor: Colors.black,
            tabs: tablist,
          ),
        ),
        body: tabBarView,
      ),
    );
  }
}
