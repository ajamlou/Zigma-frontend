// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Advert _$AdvertFromJson(Map<String, dynamic> json) {
  String url = "https://c2abc9f7.ngrok.io/adverts/advertimages/";
  return Advert(
      bookTitle: json['book_title'] as String,
      price: json['price'] as int,
      authors: json['authors'] as String,
      isbn: json['ISBN'] as String,
      contactInfo: json['contact_info'] as String,
      condition: json['condition'] as String,
      images: (json['image'] as List)
          ?.map((id) =>
              {"file": Image.network(url + id.toString() + "/"), "id": id})
          ?.toList(),
      transactionType: json['transaction_type'] as String,
      edition: json['edition'] as String,
      owner: json['owner'] as int)
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
      'image': instance.encodedImageList
    };
