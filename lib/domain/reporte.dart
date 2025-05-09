import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';


@MappableEnum() // Añade esta anotación para permitir serialización
enum MotivoReporte { noticiaInapropiada, informacionFalsa, otro }

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