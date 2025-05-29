import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_bloc.dart';
import 'package:abaez/bloc/tareas/tareas_event.dart';
import 'package:abaez/bloc/tareas/tareas_state.dart';
import 'package:abaez/components/add_task_modal.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/tarea.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/helpers/snackbar_manager.dart';
import 'package:abaez/helpers/tasks_card_helper.dart';
import 'package:abaez/helpers/dialog_helper.dart';
import 'package:abaez/views/task_detail_screen.dart';
import 'package:abaez/helpers/shared_preferences_service.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    // Cargar las tareas al entrar a la pantalla
    context.read<TareaBloc>().add(LoadTareasEvent());

    return const _TareaScreenContent();
  }
}

class _TareaScreenContent extends StatefulWidget {
  const _TareaScreenContent();

  @override
  _TareaScreenContentState createState() => _TareaScreenContentState();
}

class _TareaScreenContentState extends State<_TareaScreenContent> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  static const int _limitePorPagina = 5;

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    
    // Initialize shared preferences
    _initSharedPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    // Cuando la app vuelve al primer plano
    _initSharedPreferences();
    
    // Cargar tareas desde caché primero
    context.read<TareaBloc>().add(LoadTareasEvent());
    
    // Luego intentar sincronizar con la API si hay conexión
    _checkConnectivityAndSync();
  } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
    // Cuando la app va a segundo plano o está por cerrarse
    // Guardar estado actual en SharedPreferences
    final currentState = context.read<TareaBloc>().state;
    if (currentState is TareaLoaded) {
      context.read<TareaBloc>().add(SaveTareasEvent(currentState.tareas));
    }
  }
}

// Método para verificar conectividad y sincronizar
Future<void> _checkConnectivityAndSync() async {
  try {
    // Implementa verificación de conectividad usando connectivity_plus u otro paquete
    // Si hay conectividad, intentar sincronizar
    context.read<TareaBloc>().add(SyncTareasEvent());
  } catch (e) {
    print('Error al verificar conectividad: $e');
  }
}

  
  Future<void> _initSharedPreferences() async {
    // Get your SharedPreferencesService singleton
    final prefs = SharedPreferencesService();
    await prefs.init();
  }
  

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
          SnackBarHelper.showError(context, state.error.message);
        } else if (state is TareaOperationSuccess) {
          SnackBarHelper.showSuccess(context, state.mensaje);
        }
      },
      builder: (context, state) {
              DateTime? lastUpdated;

        if (state is TareaLoaded) {
          lastUpdated = state.lastUpdated;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is TareaLoaded
                  ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
                  : TareasConstantes.tituloAppBar,
            ),
            centerTitle: true,
            bottom: lastUpdated != null ? PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Última actualización: ${_formatDate(lastUpdated)}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ) : null,
          ),

          body: _construirCuerpoTareas(context, state),
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
    if (state is TareaInitial || (state is TareaLoading && state is! TareaLoaded)) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state is TareaError && state is! TareaLoaded) {
      return Center(
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
              onPressed: () => context.read<TareaBloc>().add(LoadTareasEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is TareaLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
        },
        child: state.tareas.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: Text(TareasConstantes.listaVacia),
                    ),
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
                      onTap: () => _mostrarDetallesTarea(context, index, state.tareas),
                      child: Stack(
                        children: [
                          TaskCardHelper.construirTarjetaDeportiva(
                            context,
                            tarea,
                            index,
                          ),
                          Positioned(
                            top: 8,
        right: 8,
        child: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _mostrarModalEditarTarea(context, tarea),
        ),
      ),
    ],
  ),
                    ),
                  );
                },
              ),
      );
    }
    return const SizedBox.shrink();
  }

void _mostrarDetallesTarea(BuildContext context, int indice, List<Tarea> tareas) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailScreen(
        tasks: tareas,
        initialIndex: indice,
      ),
    ),
  );
}
  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AddTaskModal(
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
      builder: (dialogContext) => AddTaskModal(
        onTaskAdded: (Tarea nuevaTarea) {
          context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}