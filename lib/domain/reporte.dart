import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum para representar los diferentes motivos de reportes
@MappableEnum()
enum MotivoReporte {
  NoticiaInapropiada,
  InformacionFalsa,
  Otro
}

/// Modelo para representar un reporte de noticia
@MappableClass()
class Reporte with ReporteMappable {
  /// Identificador único del reporte, opcional al crear un nuevo reporte
  final String? id;
  final String noticiaId;
  final String fecha;

  final MotivoReporte motivo;

  const Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
  });
}
