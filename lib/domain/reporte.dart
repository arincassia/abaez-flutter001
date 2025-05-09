import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

/// Enum que define los posibles motivos de reporte
@MappableEnum()
enum MotivoReporte {
  @MappableValue("noticia_inapropiada")
  noticiaInapropiada,
  
  @MappableValue("informacion_falsa")
  informacionFalsa,
  
  @MappableValue("contenido_violento")
  contenidoViolento,
  
  @MappableValue("incitacion_odio")
  incitacionOdio,
  
  @MappableValue("derechos_autor")
  derechosAutor,
  
  @MappableValue("otro")
  otro
}

/// Clase que representa un reporte de noticia
@MappableClass()
class Reporte with ReporteMappable {
  /// ID único del reporte, generado en el servidor
  @MappableField(key: '_id')
  final String? id;
  
  /// ID de la noticia reportada
  final String noticiaId;
  
  /// ID del usuario que realizó el reporte
  final String usuarioId;
  
  /// Motivo del reporte
  final MotivoReporte motivo;
  
  /// Descripción adicional (opcional)
  final String? descripcion;
  
  /// Fecha y hora del reporte en formato ISO 8601
  final String fecha;
  
  /// Indica si el reporte ha sido revisado por un administrador
  @MappableField()
  final bool revisado;

  /// Constructor
  const Reporte({
    this.id,
    required this.noticiaId,
    required this.usuarioId,
    required this.motivo,
    this.descripcion,
    required this.fecha,
    this.revisado = false,
  });
  
  /// Método de fábrica para crear un reporte con la fecha actual
  factory Reporte.crear({
    required String noticiaId,
    required String usuarioId,
    required MotivoReporte motivo,
    String? descripcion,
  }) {
    return Reporte(
      noticiaId: noticiaId,
      usuarioId: usuarioId,
      motivo: motivo,
      descripcion: descripcion,
      fecha: DateTime.now().toIso8601String(),
    );
  }
  
  /// Verifica si el reporte es reciente (menos de 24 horas)
  bool get esReciente {
    final fechaReporte = DateTime.parse(fecha);
    final ahora = DateTime.now();
    return ahora.difference(fechaReporte).inHours < 24;
  }
  
  /// Obtiene un string descriptivo del motivo
  String get motivoDescriptivo {
    switch (motivo) {
      case MotivoReporte.noticiaInapropiada:
        return 'Contenido inapropiado';
      case MotivoReporte.informacionFalsa:
        return 'Información falsa';
      case MotivoReporte.contenidoViolento:
        return 'Contenido violento';
      case MotivoReporte.incitacionOdio:
        return 'Incitación al odio';
      case MotivoReporte.derechosAutor:
        return 'Violación de derechos de autor';
      case MotivoReporte.otro:
        return 'Otro motivo';
    }
  }
}