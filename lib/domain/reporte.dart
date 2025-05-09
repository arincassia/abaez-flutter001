import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

@MappableEnum()
enum MotivoReporte { noticiaInapropiada, informacionFalsa, otro }

/// Extensión para facilitar la conversión de motivos a formatos requeridos por la API
extension MotivoReporteExtension on MotivoReporte {
  /// Convierte el motivo a un formato amigable para la API
  String toApiFormat() {
    switch (this) {
      case MotivoReporte.noticiaInapropiada:
        return 'noticia_inapropiada';
      case MotivoReporte.informacionFalsa:
        return 'informacion_falsa';
      case MotivoReporte.otro:
        return 'otro';
    }
  }

  /// Obtiene el texto para mostrar en la UI
  String toDisplayText() {
    switch (this) {
      case MotivoReporte.noticiaInapropiada:
        return 'Noticia Inapropiada';
      case MotivoReporte.informacionFalsa:
        return 'Información Falsa';
      case MotivoReporte.otro:
        return 'Otro';
    }
  }
}

@MappableClass()
class Reporte with ReporteMappable {
  @MappableField(key: '_id')
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

  // copyWith is provided by ReporteMappable mixin.
}
