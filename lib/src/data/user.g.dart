// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['id'] as int,
      json['username'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      profile: json['profile'] as int,
      hasPicture: json['has_picture'] as bool,
      adverts: (json['adverts'] as List)?.map((e) => e as int)?.toList(),
      soldBooks: json['sold_books'] as int,
      boughtBooks: json['bought_books'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email == null ? "" : instance.email,
      'id': instance.id,
      'username': instance.username,
      'token': instance.token,
      'image': instance.profile,
      'adverts': instance.adverts,
      'sold_books': instance.soldBooks,
      'bought_books': instance.boughtBooks
    };
