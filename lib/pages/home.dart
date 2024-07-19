import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player/pages/LoginScreen.dart';
import 'package:youtube_player/pages/add_list.dart';
import 'package:youtube_player/pages/all_videos.dart';
import 'package:youtube_player/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? courseStream;
  getontheload() async {
    courseStream = await DatabaseMethods().getAllCourse();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getontheload();
    super.initState();
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginscreen()));
  }

  Widget allCourse() {
    return StreamBuilder(
        stream: courseStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllVideo(
                                      image: ds["Image"],
                                      name: ds["Course"],
                                      count: ds["Count"],
                                      id: ds["Id"],
                                    )));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["Image"],
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      ds["Course"],
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "(" + ds["Count"] + " Videos)",
                                      style: TextStyle(
                                          color: Color.fromARGB(178, 5, 0, 68),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 143, 108),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddList()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YouTube Player",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: Image.asset(
                    //     "images/userimg1.jpg",
                    //     height: 50,
                    //     width: 50,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    IconButton(
                        onPressed: () {
                          logOut();
                        },
                        icon: Icon(Icons.logout))
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Stack(children: [
                Container(
                  height: 400,
                  padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 143, 108),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      Text(
                        "Hi, Ujas!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Collections of videos that play orderly and are related to a common subject.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 156, 247, 255),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: allCourse(),
                  // SingleChildScrollView(
                  //   child: Column(
                  //     children: [

                  //     ],
                  //   ),
                  // ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
