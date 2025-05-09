import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/reportes/reporte_bloc.dart';
import 'package:abaez/bloc/reportes/reporte_event.dart';
import 'package:abaez/bloc/reportes/reporte_state.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

class ReporteDialog extends StatelessWidget {
  final String noticiaId;
  final String usuarioId;

  const ReporteDialog({
    Key? key,
    required this.noticiaId,
    this.usuarioId = 'usuario_actual', // En una app real, esto vendría del sistema de autenticación
  }) : super(key: key);

  /// Método estático para mostrar el diálogo con manejo adecuado del BLoC
  static void mostrarDialogo(BuildContext context, String noticiaId, {String usuarioId = 'usuario_actual'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<ReporteBloc>.value(
          value: context.read<ReporteBloc>(),
          child: ReporteDialog(
            noticiaId: noticiaId,
            usuarioId: usuarioId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Al construir el componente, verificar el estado del reporte
    context.read<ReporteBloc>().add(CheckReporteStatus(
      noticiaId: noticiaId,
      usuarioId: usuarioId,
    ));
    
    return _ReporteDialogContent(
      noticiaId: noticiaId,
      usuarioId: usuarioId,
    );
  }
}

class _ReporteDialogContent extends StatefulWidget {
  final String noticiaId;
  final String usuarioId;

  const _ReporteDialogContent({
    required this.noticiaId,
    required this.usuarioId,
  });

  @override
  State<_ReporteDialogContent> createState() => _ReporteDialogContentState();
}

class _ReporteDialogContentState extends State<_ReporteDialogContent> {
  MotivoReporte _motivoSeleccionado = MotivoReporte.noticiaInapropiada;
  final TextEditingController _descripcionController = TextEditingController();

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reportar noticia'),
      content: BlocConsumer<ReporteBloc, ReporteState>(
        listener: (context, state) {
          if (state is ReporteExitoso) {
            Navigator.of(context).pop(true); // Cerrar diálogo con resultado exitoso
            SnackBarHelper.showSnackBar(
              context,
              'Reporte enviado correctamente',
              statusCode: 200,
            );
          } else if (state is ReporteError) {
            SnackBarHelper.showSnackBar(
              context,
              'Error: ${state.mensaje}',
              statusCode: state.statusCode ?? 400,
            );
            // No cerramos el diálogo para permitir reintentar
          } else if (state is ReporteYaEnviado) {
            Navigator.of(context).pop(true); // Cerrar diálogo porque ya hay un reporte
            SnackBarHelper.showSnackBar(
              context,
              'Ya has reportado esta noticia anteriormente',
              statusCode: 409,
            );
          }
        },
        builder: (context, state) {
          if (state is ReporteLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ReporteYaEnviado) {
            // Este caso se maneja en el listener
            return const SizedBox.shrink();
          } else if (state is ReporteDisponible || state is ReporteInitial || state is ReporteError) {
            // Mostrar formulario para reportar
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seleccione el motivo del reporte:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MotivoReporte>(
                    value: _motivoSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Motivo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: MotivoReporte.noticiaInapropiada,
                        child: Text('Noticia inapropiada'),
                      ),
                      DropdownMenuItem(
                        value: MotivoReporte.informacionFalsa,
                        child: Text('Información falsa'),
                      ),
                      DropdownMenuItem(
                        value: MotivoReporte.contenidoViolento,
                        child: Text('Contenido violento'),
                      ),
                      DropdownMenuItem(
                        value: MotivoReporte.incitacionOdio,
                        child: Text('Incitación al odio'),
                      ),
                      DropdownMenuItem(
                        value: MotivoReporte.derechosAutor,
                        child: Text('Derechos de autor'),
                      ),
                      DropdownMenuItem(
                        value: MotivoReporte.otro,
                        child: Text('Otro'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _motivoSeleccionado = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción (opcional)',
                      hintText: 'Proporcione detalles adicionales',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  if (state is ReporteError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        state.mensaje,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            );
          }
          
          // Estado no manejado
          return const Text('Estado desconocido');
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        BlocBuilder<ReporteBloc, ReporteState>(
          builder: (context, state) {
            if (state is ReporteLoading) {
              return const SizedBox.shrink(); // No mostrar botón durante carga
            }
            
            return ElevatedButton(
              onPressed: state is ReporteDisponible || state is ReporteInitial || state is ReporteError
                ? () => _enviarReporte(context)
                : null,
              child: const Text('Enviar reporte'),
            );
          },
        ),
      ],
    );
  }

  void _enviarReporte(BuildContext context) {
    try {
      // Crear objeto reporte usando factory
      final reporte = Reporte.crear(
        noticiaId: widget.noticiaId,
        usuarioId: widget.usuarioId,
        motivo: _motivoSeleccionado,
        descripcion: _descripcionController.text.isNotEmpty
            ? _descripcionController.text
            : null,
      );

      // Enviar el reporte
      context.read<ReporteBloc>().add(EnviarReporte(reporte: reporte));
    } catch (e) {
      // Capturar cualquier excepción al crear el reporte
      SnackBarHelper.showSnackBar(
        context,
        'Error al preparar el reporte: $e',
        statusCode: 500,
      );
    }
  }
}