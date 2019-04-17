import 'package:flutter/material.dart';
import './advert_page.dart';
import 'package:zigma2/main.dart';

class SearchPage extends SearchDelegate<void> {

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
    final List data = context.inheritFromWidgetOfExactType(InheritedAdvertsList()).data;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        if (data[index]["book_title"].toLowerCase().contains(query.toLowerCase())) {
          return ListTile(
            key: Key(data[index]["book_title"]),
            title: Text(data[index]["book_title"]),
            leading: Icon(Icons.book),
            trailing: Text(data[index]["authors"]),
            onTap: () {
              routeAdvertPage(context, index);
            },
          );
        }
      },
    );
  }

  void routeAdvertPage(context, index) {
    print(index.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertPage(data: data[index]),
      ),
    );
  }
}
