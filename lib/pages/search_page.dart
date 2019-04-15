import 'package:flutter/material.dart';
import './advert_page.dart';

class SearchPage extends SearchDelegate<void> {
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
        if (data[index]["book_title"]
            .toLowerCase()
            .contains(query.toLowerCase())) {
          return ListTile(
            title: Text(data[index]["book_title"]),
            leading: Icon(Icons.book),
            trailing: Text(data[index]["authors"]),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertPage(data: data[index])));
            },
          );
        }
      },
    );
  }

  void routeAdvertPage(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => AdvertPage()));
  }
}
