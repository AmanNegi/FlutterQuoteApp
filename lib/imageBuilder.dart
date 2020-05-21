import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class ImageBuilder extends StatelessWidget {
  final String text;
  final int index;

  ImageBuilder({this.text, this.index});
  int b;
  void getNumber() {
    var rng = Random();
    int a = rng.nextInt(100);
    b = a + index;
  }

  @override
  Widget build(BuildContext context) {
    getNumber();
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          // padding: EdgeInsets.only(top: 10.0),
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Card(
            color: Colors.grey[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 280,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/loading.gif",
                      image: "https://picsum.photos/800/600?random=$b",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: GoogleFonts.raleway(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
