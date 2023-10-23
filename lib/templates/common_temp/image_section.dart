import 'package:flutter/material.dart';
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../../apis/webapi.dart';

class Imagesection extends StatefulWidget {
  const Imagesection({super.key});

  @override
  State<Imagesection> createState() => ImagesectionState();
}

class ImagesectionState extends State<Imagesection> {
  static var img;
  dynamic imList = [];
  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    img = prefs.getString("profile_pic");
    return imList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: _getCert(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(
            //     itemCount: imgList.length,
            //     // shrinkWrap: true,
            //     itemBuilder: (BuildContext context, int index) {
            if (global.imageShape == global.ImageShape.circle) {
              global.profile = ClipOval(
                child: Image.network(
                  'http://resume.cognitiveitsolutions.ca/public/images/$img',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              global.profile = ClipRRect(
                // borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'http://resume.cognitiveitsolutions.ca/public/images/$img',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: global.profile,
            );
            //  });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
