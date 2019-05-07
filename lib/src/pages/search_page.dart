import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class SearchPage extends SearchDelegate<void> {
  String s = "hej Mamma";

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
  //Method that fetches the requested data from the database when you have
  //searched for a book
  void showResults(BuildContext context) async {
    super.showResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = DataProvider.of(context).advertList.getAdvertList();
    final suggestionList = query.isEmpty
        ? data
        : data.where((a) => a.bookTitle.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].bookTitle.substring(0, query.length),
              style: TextStyle(
                color: Color(0xff96070a),
                fontWeight: FontWeight.bold,
                fontSize: 17
              ),
              children: [
                TextSpan(
                  text: suggestionList[index].bookTitle.substring(query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15
                  ),
                ),
              ],
            ),
          ),
          leading: Icon(Icons.book),
          trailing: Text(suggestionList[index].authors ?? ""),
          onTap: () async {
            DataProvider.of(context)
                .routing
                .routeAdvertPage(context, data[index], false);
          },
        );
      },
    );
  }
}
