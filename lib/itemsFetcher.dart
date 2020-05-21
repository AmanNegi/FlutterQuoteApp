import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quotes_app_flutter/Quote.dart';
import 'dart:math';

class ItemFetcher {
  List<Quote> _list = List();
  int _countOfItems = 0;

  List<Quote> get list {
    var newList = _list;
    return newList;
  }

  int get countOfItems {
    return _countOfItems;
  }

  List _shuffle(List items) {
    var random = new Random();

    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<int> getItems() async {
    int returnValue;
    try {
      http.Response response = await http.get("https://type.fit/api/quotes");
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<Quote> result = Quote.fromJson(
          json.decode(response.body),
        );
        _list = result;
        _list = _shuffle(_list);
        _countOfItems = result.length;
        print(_countOfItems.toString());
        returnValue = 1;
      } else {
        returnValue = 0;
      }
    } catch (e) {
      returnValue = 0;
      print(e);
    }
    return returnValue;
  }
}
