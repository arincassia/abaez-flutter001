# Implementación del Sistema de Reportes

## Modelo Reporte con dart_mappable

El modelo `Reporte` se ha implementado utilizando la biblioteca `dart_mappable` para facilitar la serialización y deserialización de datos JSON. A continuación se muestra el código del modelo:

```dart
// filepath: lib/domain/reporte.dart
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
```

### Archivo generado por dart_mappable

El archivo `reporte.mapper.dart` se genera automáticamente por la biblioteca dart_mappable y proporciona las funcionalidades de mapeo entre objetos Dart y JSON. Entre las características principales están:

- Métodos para convertir entre JSON y objetos Dart
- Manejo de enumeraciones con valores personalizados
- Serialización correcta de campos con nombres especiales (como `_id`)

## Comportamiento al enviar un Reporte

### Flujo de éxito

1. **Selección del motivo**: El usuario selecciona un motivo del reporte desde un dropdown en el diálogo modal.

2. **Creación del objeto**: Se crea una instancia del modelo `Reporte` con los datos necesarios:
   ```dart
   final reporte = Reporte(
     noticiaId: noticiaId,
     fecha: DateTime.now().toIso8601String(),
     motivo: motivoSeleccionado,
   );
   ```

3. **Generación del JSON**: Se transforma el objeto Reporte a un formato JSON compatible con la API:
   ```dart
   final customJsonMap = {
     'noticiaId': reporte.noticiaId,
     'fecha': reporte.fecha,
     'motivo': motivo.toApiFormat(),
   };
   ```

4. **Envío al servidor**: El JSON se envía al endpoint correspondiente:
   ```dart
   final response = await _dio.post(
     ApiConstantes.reportesUrl,
     data: customJsonMap,
     options: Options(
       headers: {'Content-Type': 'application/json'},
       validateStatus: (status) => status! < 500,
     ),
   );
   ```

5. **Validación de respuesta**: Se verifica que el código de respuesta sea 200 o 201:
   ```dart
   if (response.statusCode == 201 || response.statusCode == 200) {
     debugPrint('Reporte enviado correctamente');
     return true;
   }
   ```

6. **Notificación al usuario**: Se muestra un mensaje de éxito y se cierra el diálogo:
   ```dart
   SnackBarHelper.showSnackBar(
     context,
     'Reporte enviado correctamente',
     statusCode: 200,
   );
   ```

### Manejo de errores

La aplicación maneja varios escenarios de error en múltiples capas:

#### 1. Nivel de Servicio

```dart
try {
  // Código de envío...
} on DioException catch (e) {
  // Error de timeout
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    throw ApiException(ApiConstantes.errorTimeout);
  } 
  // Error de validación (400)
  else if (e.response?.statusCode == 400) {
    throw ApiException(
      'Datos de reporte inválidos: ${e.response?.data.toString() ?? "Sin detalles"}', 
      statusCode: 400
    );
  } 
  // Error del servidor (500)
  else if (e.response?.statusCode == 500) {
    throw ApiException(
      'Error en el servidor al procesar el reporte. Contacte al equipo de backend con este detalle: ${e.response?.data.toString() ?? "Sin detalles"}',
      statusCode: 500
    );
  } 
  // Otros errores HTTP
  else {
    throw ApiException(
      ApiConstantes.errorServer,
      statusCode: e.response?.statusCode,
    );
  }
} catch (e) {
  // Errores inesperados
  debugPrint('Error inesperado al enviar reporte: $e');
  throw ApiException('Error inesperado al enviar el reporte');
}
```

#### 2. Nivel de Repositorio

El repositorio captura las excepciones del servicio y las relanza para ser manejadas por el BLoC:

```dart
Future<bool> enviarReporte({
  required String noticiaId,
  required MotivoReporte motivo,
  String? fecha,
}) async {
  try {
    return await _service.enviarReporte(
      noticiaId: noticiaId,
      motivo: motivo,
      fecha: fecha,
    );
  } catch (e) {
    if (e is ApiException) {
      rethrow; // Relanza la excepción para que la maneje el BLoC
    }
    debugPrint('Error inesperado al enviar reporte: $e');
    throw ApiException('Error inesperado al enviar reporte.');
  }
}
```

#### 3. Nivel de BLoC

El BLoC transforma las excepciones en estados para la UI:

```dart
try {
  final success = await _reporteRepository.enviarReporte(
    noticiaId: event.reporte.noticiaId,
    motivo: event.reporte.motivo,
    fecha: event.reporte.fecha,
  );

  if (success) {
    emit(ReporteSuccess(reporte: event.reporte, timestamp: DateTime.now()));
  } else {
    emit(const ReporteError(errorMessage: 'No se pudo enviar el reporte'));
  }
} on ApiException catch (e) {
  emit(ReporteError(errorMessage: e.message));
} catch (e) {
  emit(ReporteError(errorMessage: 'Error inesperado: ${e.toString()}'));
}
```

#### 4. Nivel de UI

Finalmente, la UI muestra los mensajes de error al usuario:

```dart
BlocConsumer<ReportesBloc, ReportesState>(
  listener: (context, state) {
    if (state is ReporteSuccess) {
      // Mostrar mensaje de éxito...
    } else if (state is ReporteError) {
      // Mostrar mensaje de error
      SnackBarHelper.showSnackBar(
        context,
        'Error al enviar el reporte: ${state.errorMessage}',
        statusCode: 400,
      );
    }
  },
  // Builder...
)
```

## Mejoras implementadas

1. **Formato API personalizado**: Se creó una extensión `toApiFormat()` para asegurar que los valores del enum se envíen en el formato esperado por el backend.

2. **Logs detallados**: Se agregaron logs en cada nivel para facilitar la depuración.

3. **Validación de existencia de noticias**: Antes de enviar un reporte, se verifica que la noticia exista.

4. **BLoC con ciclo de vida controlado**: El BLoC se cierra correctamente después de usar el diálogo para evitar memory leaks.

5. **Experiencia de usuario mejorada**: Se muestran indicadores de carga y mensajes claros durante todo el proceso.
