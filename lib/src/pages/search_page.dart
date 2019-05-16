import 'package:flutter/material.dart';
import 'package:zigma2/src/DataProvider.dart';

class SearchPage extends SearchDelegate<void> {
  bool haveSearched = false;
  List savedSearch;

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

  //Method that fetches the requested data from the database when you have
  //searched for a book
  Future<List> fetchResults(context) async {
    List returnList =
        await DataProvider.of(context).advertList.searchAdverts(query);
    print(returnList.toString());
    return returnList;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Hero(
      tag: 'search page',
      child: Container(
        child: Scaffold(
          body: FutureBuilder(
            future: fetchResults(context),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length == 0) {
                return Text("Inga resultat hittade :(");
              } else if (snapshot.hasData) {
                return Hero(
                  tag: 'advert page',
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 70,
                            height: 70,
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: snapshot.data[index].images.length == 0
                                    ? Image.asset("images/placeholder_book.png")
                                    : Image.network(
                                        snapshot.data[index].images[0])),
                          ),
                          onTap: () {
                            haveSearched = true;
                            DataProvider.of(context).routing.routeAdvertPage(
                                context, snapshot.data[index], false);
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data[index].bookTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFECA72C),
                                ),
                              ),
                              Text(
                                snapshot.data[index].authors,
                                style: TextStyle(color: Color(0xFF373F51)),
                              ),
                              Text("Upplaga: " + snapshot.data[index].edition)
                            ],
                          ),
                          trailing: Text(
                            snapshot.data[index].price.toString() + ":-",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF3FBE7E),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final data = DataProvider.of(context).advertList.list;
    final suggestionList = query.isEmpty
        ? data
        : data
            .where((a) =>
                a.bookTitle.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: Container(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Text("Här syns de 20 senast upplagda annonserna.",
                  style: TextStyle(
                      color: Color(0xFF373F51),
                      fontSize: 16,
                      fontStyle: FontStyle.italic))),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    text: suggestionList[index]
                        .bookTitle
                        .substring(0, query.length),
                    style: TextStyle(
                        color: Color(0xFFECA72C),
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    children: [
                      TextSpan(
                        text: suggestionList[index]
                            .bookTitle
                            .substring(query.length),
                        style: TextStyle(
                            color: Color(0xFF373F51),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                leading: Icon(Icons.book, color: Color(0xFFECA72C),),
                trailing: Text(suggestionList[index].authors ?? ""),
                onTap: () async {
                  DataProvider.of(context)
                      .routing
                      .routeAdvertPage(context, suggestionList[index], false);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
