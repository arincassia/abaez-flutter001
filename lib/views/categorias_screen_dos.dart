import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/categoria/categorias_bloc.dart';
import 'package:abaez/bloc/categoria/categoria_state.dart';
import 'package:abaez/bloc/categoria/categorias_event.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/constantes/constants.dart';

class CategoriaScreenDos extends StatelessWidget {
  const CategoriaScreenDos({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
           return Scaffold(
            appBar: AppBar(
              title: const Text('Categorías'),
            ),
            body: BlocConsumer<CategoriaBloc, CategoriaState> (
                listener: (context, state) {
                  if (state is CategoriaError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CategoriaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoriaError) {
                    return Center(child: Text(state.message));
                  } else if (state is CategoriaLoaded) {
                    CategoriaLoaded loadedState = state;
                    return _buildCategoriaList(context, state.categorias, lastUpdated:loadedState.lastUpdated);
                  }
                  return const SizedBox();
                },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateCategoriaDialog(context),
              tooltip: 'Crear Categoría',
               child: const Icon(Icons.add),
            ),
          );
        }
      ),
    );
  }

  Widget _buildCategoriaList(BuildContext context, List<Categoria> categorias, {DateTime? lastUpdated}) {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return ListTile(
          title: Text(categoria.nombre),
          subtitle: Text(categoria.descripcion),
          leading: categoria.imagenUrl != null && categoria.imagenUrl!.isNotEmpty
            ? Image.network(categoria.imagenUrl!)
            : const Icon(Icons.image_not_supported),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditCategoriaDialog(context, categoria),
                tooltip: 'Editar Categoría',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmationDialog(context, categoria),
                tooltip: 'Eliminar Categoría',
              ),
            ],
          ),
          onTap: () {
            // Aquí puedes manejar la acción al hacer clic en la categoría
          },
        );
      },
    );
  }

  void _showCreateCategoriaDialog(BuildContext context) {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final imagenUrlController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Crear Categoría'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingrese el nombre de la categoría'
              ),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ingrese la descripción'
              ),
              maxLines: 2,
            ),
            TextField(
              controller: imagenUrlController,
              decoration: const InputDecoration(
                labelText: 'URL de imagen (opcional)',
                hintText: 'https://example.com/imagen.jpg'
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nombreController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El nombre es obligatorio')),
              );
              return;
            }
            
            final nuevaCategoria = Categoria(
              id: '', // ID will be assigned by backend
              nombre: nombreController.text,
              descripcion: descripcionController.text,
              imagenUrl: imagenUrlController.text.isEmpty ? null : imagenUrlController.text,
            );
            
            context.read<CategoriaBloc>().add(CategoriaAddEvent(nuevaCategoria));
            Navigator.of(ctx).pop();
                SnackBarHelper.showSnackBar(
      context,
      ApiConstants.categorysuccessCreated, // Mensaje de éxito
      statusCode: 200, // Código de éxito
    );
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
  
  void _showEditCategoriaDialog(BuildContext context, Categoria categoria) {
    final nombreController = TextEditingController(text: categoria.nombre);
    final descripcionController = TextEditingController(text: categoria.descripcion);
    final imagenUrlController = TextEditingController(text: categoria.imagenUrl ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Categoría'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre de la categoría'
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese la descripción'
                ),
                maxLines: 2,
              ),
              TextField(
                controller: imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de imagen (opcional)',
                  hintText: 'https://example.com/imagen.jpg'
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre es obligatorio')),
                );
                return;
              }
              
              final updatedCategoria = Categoria(
                id: categoria.id,
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                imagenUrl: imagenUrlController.text.isEmpty ? null : imagenUrlController.text,
              );
              
              context.read<CategoriaBloc>().add(CategoriaUpdateEvent(updatedCategoria));
              Navigator.of(ctx).pop();
                  SnackBarHelper.showSnackBar(
      context,
      ApiConstants.categorysuccessUpdated, // Mensaje de éxito
      statusCode: 200, // Código de éxito
    );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmationDialog(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text('¿Está seguro que desea eliminar la categoría "${categoria.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            
            onPressed: () {
              context.read<CategoriaBloc>().add(CategoriaDeleteEvent(categoria.id));
              Navigator.of(ctx).pop();
                  SnackBarHelper.showSnackBar(
      context,
      ApiConstants.categorysuccessDeleted, // Mensaje de éxito
      statusCode: 200, // Código de éxito
    );
            },
            child: const Text('Eliminar'),
          ),
        ],
      
      ),
    );
  }
}