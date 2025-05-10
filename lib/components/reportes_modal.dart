import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/bloc reportes/reportes_bloc.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

/// Clase que proporciona funcionalidad para mostrar diálogos relacionados con reportes
class ReporteModal {
  /// Muestra un diálogo para reportar una noticia
  ///
  /// [context] El contexto de construcción
  /// [noticiaId] El ID de la noticia que se está reportando
  /// [onSave] Callback que se ejecutará después de enviar exitosamente el reporte
  static Future<void> mostrarDialogoReporte({
    required BuildContext context,
    required String noticiaId,
    VoidCallback? onSave,
  }) async {
    // Crear una nueva instancia del ReportesBloc para evitar problemas de ciclo de vida
    final reportesBloc = ReportesBloc();

    debugPrint('Mostrando diálogo de reporte para noticia: $noticiaId');

    if (!context.mounted) return;

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: reportesBloc,
            child: Builder(
              builder: (blocContext) {
                // Variable para almacenar el motivo seleccionado
                MotivoReporte motivoSeleccionado =
                    MotivoReporte.noticiaInapropiada;

                return StatefulBuilder(
                  builder: (builderContext, setState) {
                    return AlertDialog(
                      title: const Text('Reportar noticia'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Seleccione el motivo del reporte:'),
                          const SizedBox(height: 16),
                          DropdownButton<MotivoReporte>(
                            isExpanded: true,
                            value: motivoSeleccionado,
                            onChanged: (MotivoReporte? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  motivoSeleccionado = newValue;
                                });
                              }
                            },
                            items:
                                MotivoReporte.values.map((motivo) {
                                  String motivoTexto = '';
                                  switch (motivo) {
                                    case MotivoReporte.noticiaInapropiada:
                                      motivoTexto = 'Noticia Inapropiada';
                                      break;
                                    case MotivoReporte.informacionFalsa:
                                      motivoTexto = 'Información Falsa';
                                      break;
                                    case MotivoReporte.otro:
                                      motivoTexto = 'Otro';
                                      break;
                                  }
                                  return DropdownMenuItem<MotivoReporte>(
                                    value: motivo,
                                    child: Text(motivoTexto),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancelar'),
                        ),
                        BlocConsumer<ReportesBloc, ReportesState>(
                          listener: (context, state) {
                            debugPrint('Estado actual del BLoC: $state');
                            if (state is ReporteSuccess) {
                              // Mostrar mensaje de éxito
                              SnackBarHelper.showSnackBar(
                                context,
                                'Reporte enviado correctamente',
                                statusCode: 200,
                              );
                              // Ejecutar el callback si existe
                              if (onSave != null) {
                                onSave();
                              }
                              // Cerrar el diálogo
                              Navigator.pop(dialogContext);
                            } else if (state is ReporteError) {
                              // Mostrar mensaje de error
                              SnackBarHelper.showSnackBar(
                                context,
                                'Error al enviar el reporte: ${state.errorMessage}',
                                statusCode: 400,
                              );
                            }
                          },
                          builder: (context, state) {
                            return state is ReporteLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                  onPressed: () {
                                    debugPrint(
                                      'Creando reporte para noticia: $noticiaId',
                                    );
                                    // Crear el reporte con los datos necesarios
                                    final reporte = Reporte(
                                      noticiaId: noticiaId,
                                      fecha: DateTime.now().toIso8601String(),
                                      motivo: motivoSeleccionado,
                                    );

                                    // Depurar qué se está enviando
                                    debugPrint(
                                      'Enviando reporte: ${reporte.toMap()}',
                                    );

                                    // Enviar el evento para reportar la noticia
                                    blocContext.read<ReportesBloc>().add(
                                      ReporteSendEvent(reporte: reporte),
                                    );
                                  },
                                  child: const Text('Enviar Reporte'),
                                );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      );
    } finally {
      // Asegurarnos de cerrar el bloc después para evitar memory leaks
      debugPrint('Cerrando ReportesBloc');
      await reportesBloc.close();
    }
  }

  /// Muestra un diálogo para reportar un comentario
  ///
  /// [context] El contexto de construcción
  /// [comentarioId] El ID del comentario que se está reportando
  /// [noticiaId] El ID de la noticia asociada al comentario
  /// [onSave] Callback que se ejecutará después de enviar exitosamente el reporte
  static Future<void> mostrarDialogoReporteComentario({
    required BuildContext context,
    required String comentarioId,
    required String noticiaId,
    VoidCallback? onSave,
  }) async {
    // Similar al diálogo de reporte de noticia, pero para comentarios
    // Implementación futura si se requiere esta funcionalidad

    // Por ahora usamos el mismo diálogo pero pasando el comentarioId
    await mostrarDialogoReporte(
      context: context,
      noticiaId: noticiaId,
      onSave: onSave,
    );
  }
}
