import 'package:flutter/material.dart';
import 'package:quotes_app_flutter/Quote.dart';
import 'package:quotes_app_flutter/drawerBuilder.dart';
import 'package:quotes_app_flutter/gradientBuilder.dart';
import 'itemsFetcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'imageBuilder.dart';

class ListGenerator extends StatefulWidget {
  @override
  _ListGeneratorState createState() => _ListGeneratorState();
}

class _ListGeneratorState extends State<ListGenerator> {
  int countOfItems;
  List<Quote> list;
  RefreshController mainController;
  RefreshController errorController;
  ItemFetcher itemFetcher;
  bool value = true;
  final ScrollController _scrollController = ScrollController();
  bool _visible = false;

  Widget defaultWidget = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    itemFetcher = ItemFetcher();
    getFromSharedPrefs();
    getNewData();
    mainController = RefreshController();
    errorController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBuilder(onPressed: refresh),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          backgroundColor: Colors.white60,
          child: Icon(Icons.arrow_upward),
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Quotes App",
          style: GoogleFonts.raleway(),
          textAlign: TextAlign.center,
        ),
      ),
      body: defaultWidget,
    );
  }

  void getFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("value")) {
      setState(() {
        value = prefs.getBool("value");
      });
      print(" prefs contains value " + value.toString());
    } else {
      setState(() {
        value = true;
      });
    }
  }

  Future<int> getNewData() async {
    int value = await itemFetcher.getItems();
    print(" listGenerator the value : " + value.toString());
    setState(() {
      this.countOfItems = itemFetcher.countOfItems;
      this.list = itemFetcher.list;
    });
    getMainWidget(value);
    return value;
  }

  Widget errorBuilder() {
    return Container(
        child: SmartRefresher(
      header: ClassicHeader(
        textStyle: GoogleFonts.raleway(),
        completeIcon: Icon(
          Icons.done,
          color: Colors.green,
        ),
        failedIcon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
      controller: errorController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: refresh,
      child: Column(
        children: <Widget>[
          SvgPicture.asset("assets/error.svg"),
          Text(
            "Check your internet connection",
            style: GoogleFonts.raleway(),
          )
        ],
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    mainController.dispose();
    errorController.dispose();
  }

  void refresh() async {
    getFromSharedPrefs();
    print(" IN REFRESH ");
    int a = await getNewData();
    if (mainController.isRefresh) {
      if (a == 1)
        mainController.refreshCompleted();
      else
        mainController.refreshFailed();
    } else if (errorController.isRefresh) {
      if (a == 0)
        errorController.refreshFailed();
      else
        errorController.refreshCompleted();
    }
  }

  void getMainWidget(int val) async {
    if (val == 0) {
      defaultWidget = errorBuilder();
    } else {
      if (countOfItems == 0) {
        _visible = false;
        defaultWidget = Container(
          child: Center(
            child: Text("No items"),
          ),
        );
      } else {
        _visible = true;
        defaultWidget = SmartRefresher(
          header: ClassicHeader(
            textStyle: GoogleFonts.raleway(),
            completeIcon: Icon(
              Icons.done,
              color: Colors.green,
            ),
            failedIcon: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          controller: mainController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: refresh,
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return value
                  ? ImageBuilder(index: index, text: list[index].text)
                  : GradientBuilder(index: index, text: list[index].text);
            },
            itemCount: countOfItems,
          ),
        );
      }
    }
    setState(() {});
  }
}
