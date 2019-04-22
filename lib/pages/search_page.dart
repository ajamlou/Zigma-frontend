import 'package:flutter/material.dart';
import './advert_page.dart';
import './DataProvider.dart';

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
    List data = DataProvider.of(context).advertList.getAdvertList();
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        if (data[index].bookTitle.toLowerCase().contains(query.toLowerCase())) {
          return ListTile(
            key: Key(data[index].bookTitle),
            title: Text(data[index].bookTitle),
            leading: Icon(Icons.book),
            trailing: Text(data[index].authors ?? ""),
            onTap: () {
              routeAdvertPage(context, index, data);
            },
          );
        }
      },
    );
  }


  void routeAdvertPage(context, index, data) {
    print(index.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertPage(data: data[index]),
      ),
    );
  }
}
