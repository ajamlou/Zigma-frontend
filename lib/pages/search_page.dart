import 'package:flutter/material.dart';
import './advert.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchData extends StatefulWidget {
  @override
  SearchDataState createState() => SearchDataState();
}

class SearchDataState extends State<SearchData> {
  final String url = "https://jsonplaceholder.typicode.com/posts";
  List data;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = json.decode(res.body);
    });
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: getItemCount(data),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Text(data[index]["id"].toString()),
          );
        },
      ),
    );
  }

  int getItemCount(data) {
    if (data == null) {
      return 0;
    }
    return data.length;
  }

  List sendData(){
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }
}


class SearchPage extends SearchDelegate<Advert> {
  //List<Advert> _adverts = adverts;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Du har testat att söka!');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Text(SearchData().sendData())
    );
  }
}
