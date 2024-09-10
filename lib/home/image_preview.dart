import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewLCass extends StatefulWidget {
  String url;
  ImagePreviewLCass({this.url});
  @override
  _ImagePreviewLCassState createState() => _ImagePreviewLCassState();
}

class _ImagePreviewLCassState extends State<ImagePreviewLCass> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: Padding(
              padding: EdgeInsets.only(left: 30),
              child: InkWell(
                child: Image.asset(
                  "assets/cancel.webp",
                  width: 50,
                  height: 50,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )),
        body: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.url),
        ));
  }
}
