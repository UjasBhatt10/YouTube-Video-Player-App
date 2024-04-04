import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayVideo extends StatefulWidget {
  String name, link;
  PlayVideo({required this.name, required this.link});

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 20.0),
        ),
      ),
      body: Center(
        child: WebView(
          initialUrl: widget.link,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
