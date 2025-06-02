import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_event.dart';
import 'package:abaez/bloc/tareas/tareas_state.dart';
import 'package:abaez/bloc/tareas_contador/tareas_contador_bloc.dart';
import 'package:abaez/bloc/tareas_contador/tareas_contador_event.dart';
import 'package:abaez/components/add_task_modal.dart';
import 'package:abaez/components/last_updated_header.dart';
import 'package:abaez/components/tarea_progreso_indicator.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/helpers/dialog_helper.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/views/tarea_detalles_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc()..add(LoadTareasEvent()),
        ),
        BlocProvider<TareaContadorBloc>(
          create: (context) => TareaContadorBloc(),
        ),
      ],
      child: const _TareaScreenContent(),
    );
  }
}

class _TareaScreenContent extends StatefulWidget {
  const _TareaScreenContent();

  @override
  _TareaScreenContentState createState() => _TareaScreenContentState();
}

class _TareaScreenContentState extends State<_TareaScreenContent> {
  final ScrollController _scrollController = ScrollController();
  static const int _limitePorPagina = 5;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TareaBloc>().state;
      if (state is TareaLoaded && state.hayMasTareas) {
        context.read<TareaBloc>().add(
          LoadMoreTareasEvent(
            pagina: state.paginaActual + 1,
            limite: _limitePorPagina,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TareaBloc, TareaState>(
      listener: (context, state) {
        if (state is TareaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is TareaCompletada) {
          // Actualizamos el contador solo una vez aquí
          if (state.completada) {
            context.read<TareaContadorBloc>().add(IncrementarContador());
          } else {
            context.read<TareaContadorBloc>().add(DecrementarContador());
          }
          // Mostramos el snackbar
          SnackBarHelper.mostrarExito(
            context,
            mensaje:
                state.completada
                    ? 'Tarea completada exitosamente'
                    : 'Tarea marcada como pendiente',
          );
        } else if (state is TareaLoaded) {
          // Actualizamos primero el total y luego las completadas
          final totalCompletadas =
              state.tareas.where((t) => t.completado).length;
          final tareaContadorBloc = context.read<TareaContadorBloc>();

          // Establecemos el total de tareas
          tareaContadorBloc.add(SetTotalTareas(state.tareas.length));

          // Establecemos las completadas usando un nuevo evento
          tareaContadorBloc.add(SetCompletadas(totalCompletadas));
        }
      },
      builder: (context, state) {
        DateTime? lastUpdated;
        if (state is TareaLoaded) {
          lastUpdated = state.lastUpdated;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    ),
            title: Text(
              state is TareaLoaded
                  ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
                  : TareasConstantes.tituloAppBar,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Recargar tareas',
                onPressed: () {
                  // Forzamos la recarga desde la API
                  context.read<TareaBloc>().add(
                    LoadTareasEvent(forzarRecarga: true),
                  );

                  // Opcional: Mostrar un SnackBar para indicar la recarga
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Recargando tareas...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
 
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              LastUpdatedHeader(lastUpdated: lastUpdated),
              if (state is TareaLoaded) const TareaProgresoIndicator(),
              Expanded(child: _construirCuerpoTareas(context, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _mostrarModalAgregarTarea(context),
            tooltip: 'Agregar Tarea',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _construirCuerpoTareas(BuildContext context, TareaState state) {
    // Envolvemos todo el contenido en un RefreshIndicator
    return RefreshIndicator(
      onRefresh: () async {
        // Forzamos la recarga desde la API
        context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
      },
      child: _construirContenidoTareas(context, state),
    );
  }

  // Nuevo método para el contenido
  Widget _construirContenidoTareas(BuildContext context, TareaState state) {
    if (state is TareaInitial || state is TareaLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando tareas...'),
          ],
        ),
      );
    }

    if (state is TareaError && state is! TareaLoaded) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error.message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<TareaBloc>().add(LoadTareasEvent()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (state is TareaLoaded) {
      return state.tareas.isEmpty
          ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(child: Text(TareasConstantes.listaVacia)),
              ),
            ],
          )
          : ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.tareas.length + (state.hayMasTareas ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.tareas.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final tarea = state.tareas[index];
              return Dismissible(
                key: Key(tarea.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  return await DialogHelper.mostrarConfirmacion(
                    context: context,
                    titulo: 'Confirmar eliminación',
                    mensaje: '¿Estás seguro de que deseas eliminar esta tarea?',
                    textoCancelar: 'Cancelar',
                    textoConfirmar: 'Eliminar',
                  );
                },
                onDismissed: (_) {
                  context.read<TareaBloc>().add(DeleteTareaEvent(tarea.id!));
                },
                child: GestureDetector(
                  onTap:
                      () => _mostrarDetallesTarea(context, index, state.tareas),
                  child: construirTarjetaDeportiva(
                    tarea,
                    tarea.id!,
                    () => _mostrarModalEditarTarea(context, tarea),
                    (completado) {
                      context.read<TareaBloc>().add(
                        UpdateTareaEvent(
                          tarea.copyWith(completado: completado),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
    }

    return const SizedBox.shrink();
  }

  void _mostrarDetallesTarea(
    BuildContext context,
    int indice,
    List<Tarea> tareas,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(tareas: tareas, indice: indice),
      ),
    );
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AddTaskModal(
            taskToEdit: tarea,
            onTaskAdded: (Tarea tareaEditada) {
              context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
            },
          ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AddTaskModal(
            onTaskAdded: (Tarea nuevaTarea) {
              context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
            },
          ),
    );
  }

  // Actualizar el método construirTarjetaDeportiva
  Widget construirTarjetaDeportiva(
    Tarea tarea,
    String s,
    void Function() param2,
    Null Function(dynamic completado) param3,
  ) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: tarea.completado,
          onChanged: (bool? value) {
            if (value != null) {
              context.read<TareaBloc>().add(
                CompletarTareaEvent(tarea: tarea, completada: value),
              );
            }
          },
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completado ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(tarea.descripcion ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _mostrarModalEditarTarea(context, tarea),
        ),
      ),
    );
  }
}