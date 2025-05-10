import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

@MappableEnum() // Anotación para el enum
enum MotivoReporte {
  noticiaInapropiada,
  informacionFalsa,
  otro
}

@MappableClass() // Anotación para la clase
class Reporte with ReporteMappable {
  final String? id;
  final String noticiaId;
  final String fecha; // Usamos String para almacenar ISO 8601
  final MotivoReporte motivo;

  Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
  });
}
