import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player/pages/paly_video.dart';
import 'package:youtube_player/service/database.dart';

class AllVideo extends StatefulWidget {
  String image, name, id, count;
  AllVideo(
      {required this.image,
      required this.name,
      required this.id,
      required this.count});

  @override
  State<AllVideo> createState() => _AllVideoState();
}

class _AllVideoState extends State<AllVideo> {
  Stream? videoStream;

  getontheload() async {
    videoStream = await DatabaseMethods().getAllVideos(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getontheload();
    super.initState();
  }

  Widget allVideos() {
    return StreamBuilder(
        stream: videoStream,
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
                                  builder: (context) => PlayVideo(
                                      name: widget.name, link: ds['Link'])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              ds["Image"],
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Placeholder or error handling widget
                                return Icon(Icons
                                    .error); // You can replace this with any widget you prefer
                              },
                            ),
                          ),
                        ));
                  })
              : Container();
        });
  }

  TextEditingController youtubevideoController = new TextEditingController();

  String? getYoutubeThumbnail(String videoUrl) {
    final Uri? uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return null;
    }
    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 143, 108),
        onPressed: () {
          openDailog();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color.fromARGB(255, 0, 143, 108),
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
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                elevation: 5.0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 25),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: allVideos(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDailog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                      SizedBox(
                        width: 50.0,
                      ),
                      Text(
                        "Add Video",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontFamily: 'Poppins',
                            fontSize: 15.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Add Youtube Link'),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: youtubevideoController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Add Link"),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String? thumbnail = await getYoutubeThumbnail(
                          youtubevideoController.text);
                      int total = int.parse(widget.count);
                      total = total + 1;
                      Map<String, dynamic> addVideo = {
                        "Image": thumbnail,
                        "Link": youtubevideoController.text,
                      };
                      await DatabaseMethods()
                          .updateCount(widget.id, total.toString());
                      await DatabaseMethods().addVideo(addVideo, widget.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
