// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['email'] as String,
      json['id'] as int,
      json['username'] as String,
      json['token'] as String,
      json['image'] as int,
      (json['adverts'] as List)?.map((e) => e as int)?.toList(),
      json['sold_books'] as int,
      json['bought_books'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email == null ? "" : instance.email,
      'id': instance.id,
      'username': instance.username,
      'token': instance.token,
      'image': instance.image,
      'adverts': instance.adverts,
      'sold_books': instance.soldBooks,
      'bought_books': instance.boughtBooks
    };
