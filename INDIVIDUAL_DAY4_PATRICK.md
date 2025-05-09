# Implementación de Sistema de Reportes para Noticias

## 1. Código del modelo Reporte con la configuración de dart_mappable

El modelo `Reporte` implementa `dart_mappable` para serialización JSON, con un enum `MotivoReporte` que define los posibles motivos. La clase principal incluye campos como id, noticiaId, usuarioId, motivo, descripción y fecha, además de métodos útiles como `esReciente()` y `motivoDescriptivo()`. Las anotaciones `@MappableClass()`, `@MappableEnum()` y `@MappableField()` garantizan una correcta transformación entre objetos y JSON.

## 2. Captura de pantalla del AlertDialog con el selector de motivos

El AlertDialog para reportes presenta una interfaz clara con un título "Reportar noticia", un selector desplegable para elegir el motivo del reporte, un campo de texto multilinea opcional para detalles adicionales, y botones de "Cancelar" y "Enviar reporte". Durante el proceso de envío, se muestra un indicador de carga circular que reemplaza temporalmente el contenido del diálogo.

## 3. Descripción del comportamiento al enviar un reporte

**Caso de éxito**: Al enviar un reporte válido, se muestra brevemente un indicador de carga, luego el diálogo se cierra automáticamente, aparece un SnackBar verde con "Reporte enviado correctamente" y el botón de reporte en la tarjeta cambia a rojo indicando que la noticia ha sido reportada.

**Caso de error**: La aplicación maneja varios escenarios de error: validación (muestra errores en el formulario), reportes duplicados (SnackBar con código 409), problemas de red (mantiene el diálogo abierto con mensaje de error) y errores del servidor (SnackBar rojo con detalles). En cada caso, la interfaz informa claramente al usuario y permite acciones apropiadas como reintentar o cancelar.