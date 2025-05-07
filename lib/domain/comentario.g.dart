// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comentario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comentario _$ComentarioFromJson(Map<String, dynamic> json) => Comentario(
  id: json['_id'] as String,
  noticiaId: json['noticiaId'] as String,
  texto: json['texto'] as String,
  fecha: json['fecha'] as String,
  autor: json['autor'] as String,
  likes: (json['likes'] as num).toInt(),
  dislikes: (json['dislikes'] as num).toInt(),
);

Map<String, dynamic> _$ComentarioToJson(Comentario instance) =>
    <String, dynamic>{
      'noticiaId': instance.noticiaId,
      'texto': instance.texto,
      'fecha': instance.fecha,
      'autor': instance.autor,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
    };
