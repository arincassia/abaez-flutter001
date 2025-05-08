// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noticia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticia _$NoticiaFromJson(Map<String, dynamic> json) => Noticia(
  id: json['_id'] as String?,
  titulo: json['titulo'] as String,
  descripcion: json['descripcion'] as String,
  fuente: json['fuente'] as String,
  publicadaEl: DateTime.parse(json['publicadaEl'] as String),
  urlImagen: json['urlImagen'] as String,
  categoriaId: json['categoriaId'] as String?,
);

Map<String, dynamic> _$NoticiaToJson(Noticia instance) {
  final val = <String, dynamic>{};
  
  if (instance.id != null) {
    val['_id'] = instance.id;
  }
  
  val['titulo'] = instance.titulo;
  val['descripcion'] = instance.descripcion;
  val['fuente'] = instance.fuente;
  val['publicadaEl'] = instance.publicadaEl.toIso8601String();
  val['urlImagen'] = instance.urlImagen;
  
  if (instance.categoriaId != null) {
    val['categoriaId'] = instance.categoriaId;
  }
  
  return val;
}
