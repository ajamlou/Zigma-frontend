import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';


const _list = const [
  'Argument',
  'Beryllium',
  'Construction',
  'Danger Mouse',
  'Exactly',
  'Farsight',
  'Geology',
  'Hamstring',
  'Intellectual',
  'Jam-packed',
  'Kernel',
  'Lance',
  'Median',
  'Noose',
  'Original',
  'Purely',
];

class Searchbar extends StatefulWidget {
  @override
  _Searchbar createState() => _Searchbar();
}

// Define a corresponding State class. This class will hold the data related to
// our Form.
class _Searchbar extends State<Searchbar> {
// Create a text controller. We will use it to retrieve the current value
// of the TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
// Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  String getText() {
    return myController.text;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new MaterialSearch<String>(
        placeholder: 'Search for a book',
        getResults: (String criteria) async {
          var list = await _fetchList(criteria);
          return list.map((name) =>
          new MaterialSearchResult<String>(
            value: name,
            text: name,
            icon: Icons.person,
          )).toList();
        },
        results: _list.map((name) =>
        new MaterialSearchResult<String>(
          value: name,
          text: name,
          icon: Icons.person,
        )).toList(),
        filter: (String value, String critera) {
          return value.toString().toLowerCase().trim()
              .contains(new RegExp(r'' + critera.toLowerCase().trim() + ''));
        },
        sort: (String value, String criteria, _) {
          return 0;
        },
        onSelect: (String selected) {
          print(selected);
        },
        onSubmit: (String value) {
          print(value);
        },
      ),
    );
  }
}

