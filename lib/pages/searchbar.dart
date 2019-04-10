import 'package:flutter/material.dart';

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

  String getText(){
    return myController.text;
  }

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: myController,
      decoration: new InputDecoration(
        hintText: 'Search for a book'
      ),
    );
  }
}


