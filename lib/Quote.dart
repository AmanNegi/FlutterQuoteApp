class Quote {
  String text;
  String author;

  Quote({this.text, this.author});

  ////factory Quote.fromJson(List<Map<String, dynamic>> json) {
  //  return Quote(author: json["author"], text: json['text']);
  //}

  static List<Quote> fromJson(List<dynamic> json) {
    List<Quote> mainList = List<Quote>();
    print(json.runtimeType);
    for (var a in json) {
      mainList.add(Quote(author: a['author'], text: a['text']));
    }
    return mainList;
  }
}
