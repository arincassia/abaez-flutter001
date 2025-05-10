# INDIVIDUAL_DAY4_Daniela

## Código del modelo Reporte con la configuración de dart_mappable

El modelo `Reporte` se ha implementado utilizando la biblioteca `dart_mappable` para facilitar la serialización y deserialización de datos JSON. A continuación se muestra el código del modelo:

```dart
// filepath: /home/daniela/projects/abaez-flutter001/lib/domain/reporte.dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reporte.mapper.dart';

@MappableEnum()
enum MotivoReporte {
  noticiaInapropiada,
  informacionFalsa,
  otro,
}

@MappableClass(ignoreNull: true)
class Reporte with ReporteMappable {
  final String? id;
  final String noticiaId;
  final DateTime fecha;
  final MotivoReporte motivo;

  Reporte({
    this.id,
    required this.noticiaId,
    required this.fecha,
    required this.motivo,
  });
}
```

El modelo incluye:
- Un enum `MotivoReporte` decorado con `@MappableEnum()` con tres opciones posibles: `noticiaInapropiada`, `informacionFalsa`, y `otro`.
- Campos básicos como `id` (opcional), `noticiaId` (ID de la noticia reportada), `fecha`, y `motivo`.
- La anotación `@MappableClass(ignoreNull: true)` para la generación automática de código de serialización, que omite valores nulos.
- El mixin `ReporteMappable` que proporciona métodos como `toMap()` y `toJson()` para la conversión entre objetos Dart y JSON.
- El archivo generado `reporte.mapper.dart` contiene toda la lógica de serialización/deserialización.

## Descripción del comportamiento al enviar un reporte

### Éxito
Cuando el usuario envía un reporte correctamente:
1. El botón "Enviar" del diálogo ejecuta la acción `reporteBloc.add(EnviarReporte(reporte))`
2. El estado del bloc cambia a `ReporteLoading` mientras se procesa la solicitud
3. El repositorio `ReporteRepository` verifica primero que la noticia exista mediante `_noticiaService.getNoticiaById(noticiaId)`
4. Luego crea una instancia de `Reporte` y la envía mediante `_reporteService.enviarReporte(reporte)`
5. Cuando la operación se completa con éxito, el estado del bloc cambia a `ReporteSuccess`
6. Se cierra el diálogo automáticamente
7. Se muestra un SnackBar con el mensaje "Reporte enviado correctamente" con código de estado 200
8. El `reporteBloc` es cerrado para liberar recursos

### Error
Cuando ocurre un error al enviar un reporte:
1. Si la noticia no existe o fue eliminada, se lanza una `ApiException`
2. Si ocurre cualquier otro error durante el proceso, se captura y se lanza una `ApiException` genérica
3. El estado del bloc cambia a `ReporteError` con el mensaje de error correspondiente
4. El diálogo permanece abierto, permitiendo al usuario intentar nuevamente o cancelar
5. Se muestra un SnackBar con el mensaje "Error al enviar el reporte: [mensaje del error]" con código de estado 400

## Verificación de funcionalidad

He verificado el correcto funcionamiento de la funcionalidad de reportes:

1. **Éxito al enviar un reporte**: Al seleccionar la opción "Reportar" en una noticia, seleccionar un motivo y presionar "Enviar", el sistema mostró correctamente el mensaje de éxito.

2. **Error simulado**: Para probar el manejo de errores, se intentó reportar una noticia con un ID inválido, lo que generó correctamente el mensaje de error.

3. **Compatibilidad con pantallas existentes**: La implementación de la funcionalidad de reportes no afectó el funcionamiento de las demás pantallas de la aplicación.

La documentación del repositorio `ReporteRepository` es clara y explica el proceso en detalle:
```dart
/// Enviar un reporte de una noticia
/// 
/// Este método:
/// 1. Verifica que la noticia exista consultando /noticias/<noticiaId>
/// 2. Envía el reporte a /reportes usando una solicitud POST
/// 
/// Parámetros:
/// - noticiaId: ID de la noticia a reportar
/// - motivo: Motivo del reporte (enum MotivoReporte)
/// 
/// Excepciones:
/// - ApiException: Si la noticia no existe o si ocurre un error durante el proceso
```