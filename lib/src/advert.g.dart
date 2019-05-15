// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Advert _$AdvertFromJson(Map<String, dynamic> json) {
  return Advert(
      json['book_title'] as String,
      json['price'] as int,
      json['authors'] as String,
      json['ISBN'] as String,
      json['contact_info'] as String,
      json['condition'] as String,
      (json['image'] as List)?.map((e) => e as String)?.toList(),
      json['transaction_type'] as String,
      json['edition'] as String,
      json['owner'] as int)
    ..id = json['id'] as int
    ..state = json['state'] as String;
}

Map<String, dynamic> _$AdvertToJson(Advert instance) => <String, dynamic>{
      'book_title': instance.bookTitle,
      'owner': instance.owner,
      'ISBN': instance.isbn == "" ? "Ej Angett" : instance.isbn,
      'condition': instance.condition,
      'edition': instance.edition == "" ? "Ej Angett" : instance.edition,
      'price': instance.price,
      'authors': instance.authors,
      'state': instance.state,
      'transaction_type': instance.transactionType,
      'contact_info': instance.contactInfo,
      'image': instance.images
    };
