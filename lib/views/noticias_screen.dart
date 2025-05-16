import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:abaez/bloc/reportes/reportes_bloc.dart';
import 'package:abaez/bloc/reportes/reportes_event.dart';
import 'package:abaez/bloc/reportes/reportes_state.dart';
import 'package:abaez/domain/reporte.dart';
import 'package:abaez/helpers/category_helper.dart';
import 'package:abaez/views/comentarios/comentarios_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_event.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_state.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/components/noticia_dialogs.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/helpers/noticia_card_helper.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/error_helper.dart';
import 'package:abaez/views/category_screen.dart';
import 'package:abaez/views/preferencia_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:watch_it/watch_it.dart';
class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoticiasBloc()..add(const FetchNoticias()),
        ),
        BlocProvider(
          create:
              (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        // Asegurarnos de usar el BLoC global    
        BlocProvider.value(value: context.read<ComentarioBloc>()),
      ],
      child: BlocConsumer<NoticiasBloc, NoticiasState>(
        listener: (context, state) {
          if (state is NoticiasError) {
            _mostrarError(context, state.statusCode);
          }
        },
        builder: (context, state) {
          // Acceder al estado de preferencias para mostrar información de filtros
          final preferenciaState = context.watch<PreferenciaBloc>().state;
          final filtrosActivos =
              preferenciaState.categoriasSeleccionadas.isNotEmpty;

          return Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    NoticiaConstantes.tituloApp,
                    style: TextStyle(color: Colors.white),
                  ),
                  if (state
                      is NoticiasLoaded) // Check if state is NoticiasLoaded before accessing lastUpdated
                    Text(
                      'Última actualización: ${(DateFormat(NoticiaConstantes.formatoFecha)).format(state.lastUpdated)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 248, 174, 206),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Agregar Noticia',
                  onPressed: () async {                    try {
                      await NoticiaModal.mostrarModal(
                        context: context,
                        noticia: null,
                        onSave: (_, noticiaActualizada) {
                          // Para el caso de crear, simplemente recargamos las noticias
                          context.read<NoticiasBloc>().add(
                            const FetchNoticias(),
                          );
                          SnackBarHelper.showSnackBar(
                            context,
                            ApiConstantes.newssuccessCreated,
                            statusCode: 200,
                          );
                        },
                      );
                      if (!context.mounted) return;
                    } catch (e) {
                      if (e is ApiException) {
                        _mostrarError(context, e.statusCode);
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.category),
                  tooltip: 'Categorías',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: filtrosActivos ? Colors.amber : null,
                  ),
                  tooltip: 'Preferencias',
                  onPressed: () {
                    Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PreferenciasScreen(),
                      ),
                    ).then((categoriasSeleccionadas) {
                      if (!context.mounted) return;
                      if (categoriasSeleccionadas != null) {
                        if (categoriasSeleccionadas.isNotEmpty) {
                          // Si hay categorías seleccionadas, aplicar filtro
                          context.read<NoticiasBloc>().add(
                            FilterNoticiasByPreferencias(
                              categoriasSeleccionadas,
                            ),
                          );
                        } else {
                          // Si la lista está vacía, usar el evento FetchNoticias para mostrar todas
                          context.read<NoticiasBloc>().add(
                            const FetchNoticias(),
                          );
                        }
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refrescar',
                  onPressed: () {
                    // Al refrescar, aplicar los filtros actuales si existen
                    final categoriasSeleccionadas =
                        context
                            .read<PreferenciaBloc>()
                            .state
                            .categoriasSeleccionadas;
                    if (categoriasSeleccionadas.isNotEmpty) {
                      context.read<NoticiasBloc>().add(
                        FilterNoticiasByPreferencias(categoriasSeleccionadas),
                      );
                    } else {
                      context.read<NoticiasBloc>().add(const FetchNoticias());
                      CategoryHelper.refreshCategories();
                    }
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Chip para mostrar filtros activos
                if (filtrosActivos)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    color: Colors.grey[300],
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filtrado por ${preferenciaState.categoriasSeleccionadas.length} categorías',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Limpiar filtros y mostrar todas las noticias
                            context.read<PreferenciaBloc>().add(
                              const ReiniciarFiltros(),
                            );
                            context.read<NoticiasBloc>().add(
                              const FetchNoticias(),
                            );
                            SnackBarHelper.showSnackBar(
                              context,
                              'Filtros reiniciados.',
                              statusCode: 200,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Limpiar filtros',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(NoticiasState state) {
    if (state is NoticiasLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NoticiasLoaded) {
      final noticias = state.noticiasList;
      if (noticias.isEmpty) {
        return const Center(child: Text(NoticiaConstantes.listaVacia));
      } else {
        return ListView.separated(
          itemCount: noticias.length,
          itemBuilder: (context, index) {
            final noticia = noticias[index];
            return NoticiaCardHelper.buildNoticiaCard(
              noticia: noticia,
              onEdit: () async {
                try {
                  await _editarNoticia(context, noticia);
                } catch (e) {
                  if (e is ApiException) {
                    if (!context.mounted) return;
                    _mostrarError(context, e.statusCode);
                  }
                }
              },
              onReport: () async {
                // Mostrar diálogo de reporte
                await _mostrarDialogoReporte(context, noticia.id!);
              },
              onDelete: () async {
                final confirmacion = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar Noticia'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar esta noticia? Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmacion == true) {
                  try {
                    if (!context.mounted) return;
                    context.read<NoticiasBloc>().add(
                      DeleteNoticia(noticia.id!),
                    );
                    SnackBarHelper.showSnackBar(
                      context,
                      ApiConstantes.newssuccessDeleted,
                      statusCode: 200,
                    );
                  } catch (e) {
                    if (e is ApiException) {
                      if (!context.mounted) return;
                      _mostrarError(context, e.statusCode);
                    }
                  }
                }
              },
              onComment: () async {
                // Abrir el diálogo de comentarios
                if (!context.mounted) return;

                // Mostrar el diálogo de comentarios
                await Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ComentariosScreen(noticiaId: noticia.id!),
                      ),
                    )
                    .then((_) {
                      // Cuando el diálogo se cierra, recargar toda la página de noticias
                      if (context.mounted) {
                        // Recargamos todas las noticias
                        context.read<NoticiasBloc>().add(const FetchNoticias());

                        // También actualizamos el contador específico de comentarios
                        context.read<ComentarioBloc>().add(
                          GetNumeroComentarios(noticiaId: noticia.id!),
                        );
                      }
                    });
              },
            );
          },
          separatorBuilder:
              (context, index) =>
                  const Divider(color: Colors.grey, thickness: 0.5, height: 1),
        );
      }
    }
    // Estado predeterminado o error
    return const Center(child: Text('Algo salió mal al cargar las noticias.'));  }  
  
  Future<void> _editarNoticia(BuildContext context, Noticia noticia) async {
    await NoticiaModal.mostrarModal(
      context: context,
      noticia: noticia.toJson(),
      onSave: (oldNoticia, noticiaActualizada) {
        // Crear una nueva instancia de Noticia con los datos actualizados
        final noticiaModel = Noticia(
          id: noticia.id,
          titulo: noticiaActualizada['titulo'],
          descripcion: noticiaActualizada['descripcion'],
          fuente: noticiaActualizada['fuente'],
          publicadaEl: DateTime.parse(noticiaActualizada['publicadaEl']),
          urlImagen: noticiaActualizada['urlImagen'],
          categoriaId: noticiaActualizada['categoriaId'],
        );

        // Llamar al evento UpdateNoticia del bloc
        context.read<NoticiasBloc>().add(UpdateNoticia(noticia.id!, noticiaModel));
        
        // Mostrar mensaje de éxito
        SnackBarHelper.showSnackBar(
          context,
          ApiConstantes.newssuccessUpdated,
          statusCode: 200,
        );

        // También recargamos las noticias para asegurar que se muestren actualizadas
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            context.read<NoticiasBloc>().add(const FetchNoticias());
          }
        });
      },
    );
  }

  void _mostrarError(BuildContext context, int? statusCode) {
    final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
    final message = errorData['message'];

    SnackBarHelper.showSnackBar(
      context,
      message,
      statusCode:
          statusCode, // Pasar el código de estado para el color adecuado
    );
  }

  /// Muestra un diálogo para reportar una noticia
  Future<void> _mostrarDialogoReporte(
    BuildContext context,
    String noticiaId,
  ) async {
    MotivoReporte motivoSeleccionado = MotivoReporte.otro;

    // Obtener una instancia fresca del ReporteBloc
    final reporteBloc = di<ReporteBloc>();

    await showDialog(
      context: context,
      barrierDismissible: false, // Evitar cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: reporteBloc,
          child: BlocConsumer<ReporteBloc, ReporteState>(
            listener: (context, state) {
              if (state is ReporteCreated) {
                SnackBarHelper.showSuccess(
                  context,
                  'Reporte enviado correctamente',
                );
                Navigator.of(
                  context,
                ).pop(); // Cerrar el diálogo cuando el reporte se ha creado
              } else if (state is ReporteError) {
                SnackBarHelper.showClientError(
                  context,
                  'Error al enviar el reporte: ${state.message}',
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                title: const Text('Reportar Noticia'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Por favor, seleccione el motivo del reporte:'),
                    const SizedBox(height: 16),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return DropdownButton<MotivoReporte>(
                          value: motivoSeleccionado,
                          isExpanded: true,
                          items:
                              MotivoReporte.values.map((MotivoReporte motivo) {
                                String motivoText;
                                switch (motivo) {
                                  case MotivoReporte.noticiaInapropiada:
                                    motivoText = 'Noticia Inapropiada';
                                    break;
                                  case MotivoReporte.informacionFalsa:
                                    motivoText = 'Información Falsa';
                                    break;
                                  case MotivoReporte.otro:
                                    motivoText = 'Otro';
                                    break;
                                }
                                return DropdownMenuItem<MotivoReporte>(
                                  value: motivo,
                                  child: Text(motivoText),
                                );
                              }).toList(),
                          onChanged: (MotivoReporte? valor) {
                            if (valor != null) {
                              setState(() {
                                motivoSeleccionado = valor;
                              });
                            }
                          },
                        );
                      },
                    ),
                    if (state is ReporteLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed:
                        state is ReporteLoading
                            ? null // Deshabilitar el botón si está cargando
                            : () {
                              // Reiniciar el estado del bloc si hubo un error previo
                              if (state is ReporteError) {
                                context.read<ReporteBloc>().add(
                                  ReporteInitEvent(),
                                );
                              }

                              // Enviar el reporte utilizando el bloc con un delay
                              // para asegurar que la UI se actualice
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  if(!context.mounted) return;
                                  context.read<ReporteBloc>().add(
                                    ReporteCreateEvent(
                                      noticiaId: noticiaId,
                                      motivo: motivoSeleccionado,
                                    ),
                                  );
                                },
                              );
                            },
                    child: const Text('Enviar Reporte'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
