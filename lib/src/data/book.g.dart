// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
      title: json['xsearch']['list'][0]['title'] as String,
      authors: json['xsearch']['list'][0]['creator'] as String,
      isbn: json['xsearch']['list'][0]['isbn'] is List
          ? json['xsearch']['list'][0]['isbn']
              .reduce((curr, next) => curr +", "+ next)
          : json['xsearch']['list'][0]['isbn'] as String);
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'title': instance.title,
      'isbn': instance.isbn,
      'creator': instance.authors
    };
