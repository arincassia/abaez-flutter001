// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categoria _$CategoriaFromJson(Map<String, dynamic> json) => Categoria(
  id: json['id'] as String?,
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String,
  imagenUrl: json['imagenUrl'] as String?,
);

Map<String, dynamic> _$CategoriaToJson(Categoria instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'descripcion': instance.descripcion,
  'imagenUrl': instance.imagenUrl,
};
