// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsInfo _$NewsInfoFromJson(Map<String, dynamic> json) {
  return NewsInfo(
      json['mId'] as int, json['mTitle'] as String, json['mBody'] as String);
}

Map<String, dynamic> _$NewsInfoToJson(NewsInfo instance) => <String, dynamic>{
      'mId': instance.mId,
      'mTitle': instance.mTitle,
      'mBody': instance.mBody
    };
