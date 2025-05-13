import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum que define los posibles motivos de reporte
@MappableEnum()
enum MotivoReporte { 
  noticiaInapropiada,
  informacionFalsa, 
  otro 
}

/// Clase que representa un reporte de noticia
@MappableClass()
class Reporte with ReporteMappable {
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
