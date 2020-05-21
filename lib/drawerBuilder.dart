import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerBuilder extends StatefulWidget {
  final Function onPressed;
  DrawerBuilder({this.onPressed});
  @override
  _DrawerBuilderState createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends State<DrawerBuilder> {
  bool value ;
  SharedPreferences prefs;

  @override
  void initState() {
    getFromSharedPrefs();
    super.initState();
  }

  void getFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("value")) {
      setState(() {
        value = prefs.getBool("value");
      });
    } else {
      setState(() {
        value = true;
      });
    }
  }

  void saveToSharedPrefs(bool val) async {
    setState(() {
      value = val;
    });
    prefs.setBool("value", value);
    widget.onPressed();
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarColor,
              //   gradient: LinearGradient(
              //    begin: Alignment.topLeft,
              //    end: Alignment.bottomRight,
              // colors: [Colors.grey, Colors.blueGrey],
            ),
            // ),
          ),
          SwitchListTile(
              title: Text("Use network images"),
              subtitle: Text("Network usage to load images"),
              activeColor: Colors.greenAccent,
              value: value,
              onChanged: saveToSharedPrefs),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: Colors.blueGrey,
              size: 30,
            ),
            dense: true,
            onTap: () {
              _launchURL(
                  "asterJoules@gmail.com", "Feedback", "Enter your error here");
            },
            title: Text("Give Feedback"),
            subtitle: Text("Report any issues"),
          ),
          Divider(),
          Spacer(),
          Divider(
            color: Colors.grey,
          ),
          Text("@AsterJoules", style: GoogleFonts.oswald()),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
