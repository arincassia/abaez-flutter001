// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noticia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticia _$NoticiaFromJson(Map<String, dynamic> json) => Noticia(
  id: json['_id'] as String? ?? '',
  titulo: json['titulo'] as String? ?? '',
  contenido: json['descripcion'] as String? ?? '',
  fuente: json['fuente'] as String? ?? '',
  publicadaEl: Noticia._parseDateTime(json['publicadaEl'] as String?),
  imagenUrl: json['urlImagen'] as String?,
  categoriaId: json['categoriaId'] as String? ?? '',
);

Map<String, dynamic> _$NoticiaToJson(Noticia instance) => <String, dynamic>{
  '_id': instance.id,
  'titulo': instance.titulo,
  'descripcion': instance.contenido,
  'fuente': instance.fuente,
  'publicadaEl': instance.publicadaEl.toIso8601String(),
  'urlImagen': instance.imagenUrl,
  'categoriaId': instance.categoriaId,
};
