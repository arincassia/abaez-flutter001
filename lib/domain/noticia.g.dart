// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noticia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticia _$NoticiaFromJson(Map<String, dynamic> json) => Noticia(
  id: json['id'] as String,
  titulo: json['titulo'] as String,
  descripcion: json['descripcion'] as String,
  fuente: json['fuente'] as String,
  publicadaEl: DateTime.parse(json['publicadaEl'] as String),
  imageUrl: json['imageUrl'] as String,
  categoriaId: json['categoriaId'] as String?,
);

Map<String, dynamic> _$NoticiaToJson(Noticia instance) => <String, dynamic>{
  'id': instance.id,
  'titulo': instance.titulo,
  'descripcion': instance.descripcion,
  'fuente': instance.fuente,
  'publicadaEl': instance.publicadaEl.toIso8601String(),
  'imageUrl': instance.imageUrl,
  'categoriaId': instance.categoriaId,
};
