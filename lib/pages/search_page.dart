import 'package:flutter/material.dart';
import './advert.dart';

class SearchPage extends SearchDelegate<Advert> {
  final List data;

  SearchPage({this.data});

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
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        if (data[index]["book_title"].toLowerCase().contains(query.toLowerCase())) {
          return Card(
            child: MaterialButton(
              onPressed: (){query = data[index]["book_title"];},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.book),
                  Column(
                    children: <Widget>[
                      Text(data[index]["book_title"]),
                      Text(data[index]["authors"]),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}