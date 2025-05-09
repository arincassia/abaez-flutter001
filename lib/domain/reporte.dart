import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum para los motivos del reporte
@MappableEnum() // Añade esta anotación para permitir serialización
enum MotivoReporte { noticiaInapropiada, informacionFalsa, otro }

/// Modelo Reporte con serialización/deserialización usando dart_mappable
@MappableClass()
class Reporte with ReporteMappable {
  final String? id; 
  final String noticiaId;
  final String fecha; 
  final MotivoReporte motivo;

  Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
  });
}