import 'package:flutter/material.dart';
import './advert.dart';
import 'dart:collection';


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
      onPressed: (){close(context,null);},
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Du har testat att söka!');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return AdvertList();
  }
}
