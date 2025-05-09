# Implementación de la Funcionalidad de Reportes de Noticias

Este documento describe la implementación de la funcionalidad para reportar noticias inapropiadas en la aplicación. Se detalla el modelo de datos, la configuración de serialización con dart_mappable, y el comportamiento del sistema al enviar reportes.

## Modelo de Datos Reporte con dart_mappable

El modelo `Reporte` está definido con soporte para serialización/deserialización usando dart_mappable:

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

@MappableEnum() // Anotación para serializar el enum
enum MotivoReporte { 
  NoticiaInapropiada, 
  InformacionFalsa, 
  Otro 
}

/// Modelo que representa un reporte de una noticia
@MappableClass()
class Reporte with ReporteMappable {
  /// Identificador único del reporte (opcional)
  final String? id;
  
  /// Identificador de la noticia reportada
  final String noticiaId;
  
  /// Fecha del reporte en formato ISO 8601
  final String fecha;
  
  /// Motivo del reporte
  final MotivoReporte motivo;
  
  /// Comentario adicional opcional
  final String? comentarioAdicional;

  /// Constructor
  Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
    this.comentarioAdicional,
  });

  /// Método factory para crear un reporte con la fecha actual
  factory Reporte.crearAhora({
    String? id,
    required String noticiaId,
    required MotivoReporte motivo,
    String? comentarioAdicional,
  }) {
    return Reporte(
      id: id,
      noticiaId: noticiaId,
      fecha: DateTime.now().toIso8601String(),
      motivo: motivo,
      comentarioAdicional: comentarioAdicional,
    );
  }
  
  /// Métodos de ayuda para serialización/deserialización
  Map<String, dynamic> toJson() => toMap();
  
  static Reporte fromJson(Map<String, dynamic> json) {
    return MapperContainer.globals.fromMap<Reporte>(json);
  }
}
```

La configuración con dart_mappable genera automáticamente código para la serialización y deserialización en el archivo `reporte.mapper.dart` mediante la directiva `part`. 

## Estructura de la Arquitectura

La funcionalidad de reportes sigue la arquitectura Clean Architecture con los siguientes componentes:

1. **Modelo de Dominio**: `Reporte` en `lib/domain/reporte.dart`
2. **Repositorio**: `ReporteRepository` en `lib/data/reporte_repository.dart`
3. **Servicio API**: `ReporteService` en `lib/api/service/reporte_service.dart`
4. **BLoC**: `ReporteBloc`, `ReporteEvent` y `ReporteState` en `lib/bloc/reporte/`
5. **UI**: Implementada en `lib/views/noticias_screen.dart` como un diálogo

## Comportamiento al Enviar un Reporte

### Proceso de Envío Exitoso

Cuando un usuario envía un reporte y la operación es exitosa:

1. El usuario hace clic en el botón de reporte en una tarjeta de noticia.
2. Se muestra un AlertDialog con un dropdown para seleccionar el motivo (NoticiaInapropiada, InformacionFalsa, Otro).
3. El usuario selecciona un motivo y opcionalmente agrega un comentario adicional.
4. Al hacer clic en "Enviar Reporte", se emite el evento `EnviarReporte` al `ReporteBloc`.
5. El `ReporteBloc` maneja el evento y emite estados:
   - `ReporteLoading`: mientras se procesa la solicitud.
   - `ReporteSuccess`: cuando el envío es exitoso.
6. Se muestra un SnackBar con el mensaje "Reporte enviado correctamente".
7. El diálogo se cierra automáticamente.

Ejemplo de flujo de código para el caso de éxito:

```dart
context.read<ReporteBloc>().add(
  EnviarReporte(
    noticiaId: noticiaId,
    motivo: motivoSeleccionado,
    comentarioAdicional: comentarioAdicional,
  ),
);

// En el BlocConsumer...
if (state is ReporteSuccess) {
  // Cerrar el diálogo
  Navigator.of(dialogContext).pop();
  // Mostrar mensaje de éxito
  SnackBarHelper.showSnackBar(
    context,
    state.mensaje,
    statusCode: 200,
  );
}
```

### Manejo de Errores

Cuando ocurre un error durante el envío del reporte:

1. El `ReporteBloc` captura la excepción y emite un estado `ReporteError`.
2. El diálogo permanece abierto.
3. Se muestra un SnackBar con el mensaje de error específico.
4. Los posibles errores incluyen:
   - La noticia no existe o ha sido eliminada (código 404)
   - Problemas de red o de conexión
   - Errores del servidor 
   - Errores de validación

Ejemplo de código para el manejo de errores:

```dart
try {
  // Intentar enviar el reporte
  await reporteRepository.enviarReporte(reporte);
  emit(ReporteSuccess(mensaje: 'Reporte enviado correctamente'));
} on ApiException catch (e) {
  // Capturar excepciones específicas de la API
  emit(ReporteError(
    errorMessage: e.message,
    statusCode: e.statusCode,
  ));
} catch (e) {
  // Capturar cualquier otra excepción
  emit(ReporteError(
    errorMessage: 'Error inesperado: ${e.toString()}',
  ));
}

// En el BlocConsumer...
if (state is ReporteError) {
  // Mostrar mensaje de error
  SnackBarHelper.showSnackBar(
    context,
    state.errorMessage,
    statusCode: state.statusCode ?? 400,
  );
}
```

### Proceso de verificación

El sistema también verifica que la noticia que se está reportando exista antes de procesar el reporte:

```dart
// En ReporteRepository
Future<void> _verificarNoticiaExiste(String noticiaId) async {
  try {
    await _noticiasService.obtenerNoticiaPorId(noticiaId);
  } on ApiException catch (e) {
    if (e.statusCode == 404) {
      throw ApiException(
        'No se puede reportar: La noticia no existe o ha sido eliminada',
        statusCode: 404,
      );
    }
    rethrow;
  }
}
```
