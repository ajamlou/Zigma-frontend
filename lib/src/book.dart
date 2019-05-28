import 'dart:convert';
import 'package:http/http.dart' as http;

part 'book.g.dart';

class Book {
  final String title;
  final String authors;
  final String isbn;

  Book({this.title, this.authors, this.isbn});

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson(Book book) => _$BookToJson(book);
}


Future<Book> getBookByIsbn(String isbn)async{
  String url = "http://libris.kb.se/xsearch?query="+isbn+"&format=json&database=libris&n=1";
  final response =  await http.get(Uri.parse(url));
  //print(response.body.toString());
  final resBody = json.decode(utf8.decode(response.bodyBytes));
  print(resBody);
  return Book.fromJson(resBody);
 }
