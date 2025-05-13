import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/categorias/categorias_bloc.dart';
import 'package:abaez/bloc/categorias/categorias_event.dart';
import 'package:abaez/bloc/categorias/categorias_state.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/bloc/preferencia/preferencia_state.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

class PreferenciasScreen extends StatelessWidget {

  const PreferenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preferencias'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<PreferenciaBloc>().add(const ReiniciarFiltros()),
              tooltip: 'Restablecer filtros',
            ),
          ],
        ),
        body: BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, categoriaState) {
            if (categoriaState is CategoriaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (categoriaState is CategoriaError) {
              return _buildErrorWidget(
                context,
                'Error al cargar categorías: ${categoriaState.message}',
                () => context.read<CategoriaBloc>().add(CategoriaInitEvent())
              );
            } else if (categoriaState is CategoriaLoaded) {
              return BlocBuilder<PreferenciaBloc, PreferenciaState>(
                builder: (context, preferenciasState) {
                  if (preferenciasState is PreferenciaError) {
                    return _buildErrorWidget(
                      context,
                      'Error de preferencias: ${preferenciasState.mensaje}',
                      () => context.read<PreferenciaBloc>().add(const CargarPreferencias())
                    );
                  }

                  return _buildListaCategorias(
                    context,
                    preferenciasState,
                    categoriaState.categorias,
                  );
                },
              );
            } else {
              return const Center(child: Text('Estado desconocido'));
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<PreferenciaBloc, PreferenciaState>(
          builder: (context, state) {
            // Determinar si el botón debe estar habilitado
            final bool isEnabled = state is! PreferenciaError;

            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state is PreferenciaError
                        ? 'Error al cargar preferencias'
                        : 'Categorías seleccionadas: ${state.categoriasSeleccionadas.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: state is PreferenciaError ? Colors.red : null,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isEnabled ? () => _aplicarFiltros(context, state) : null,
                      child: const Text('Aplicar filtros'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListaCategorias(
    BuildContext context,
    PreferenciaState state,
    List<Categoria> categorias,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        final isSelected = state.categoriasSeleccionadas.contains(categoria.id);

        return CheckboxListTile(
          title: Text(
            categoria.nombre,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            categoria.descripcion,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: isSelected,
          onChanged: (_) => _toggleCategoria(context, categoria.id!, isSelected),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  void _toggleCategoria(BuildContext context, String categoriaId, bool isSelected) {
    context.read<PreferenciaBloc>().add(
      CambiarCategoria(
        categoria: categoriaId,
        seleccionada: !isSelected,
      ),
    );
  }

  void _aplicarFiltros(BuildContext context, PreferenciaState state) {
    // Verificar que no sea un estado de error
    if (state is PreferenciaError) {
      SnackBarHelper.showSnackBar(context, 'No se pueden aplicar los filtros debido a un error');
      return;
    }

    // Continuar con el flujo normal
    context.read<PreferenciaBloc>().add(
      SavePreferencias(categoriasSeleccionadas: state.categoriasSeleccionadas),
    );

    SnackBarHelper.showSuccess(
      context,
      state.categoriasSeleccionadas.isEmpty
        ? 'Mostrando todas las noticias'
        : 'Filtros aplicados correctamente'
    );

    Navigator.pop(context, state.categoriasSeleccionadas);
  }

  Widget _buildErrorWidget(BuildContext context, String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
