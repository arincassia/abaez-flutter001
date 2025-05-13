import 'package:abaez/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/categorias/categorias_bloc.dart';
import 'package:abaez/bloc/categorias/categorias_event.dart';
import 'package:abaez/bloc/categorias/categorias_state.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:intl/intl.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriaBloc()..add(CategoriaInitEvent()),
        ),
      ],
      child: _CategoryScreenContent(),
    );
  }
}

class _CategoryScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: const Color.fromARGB(255, 248, 174, 206),
        actions: [
          BlocBuilder<CategoriaBloc, CategoriaState>(
            builder: (context, state) {
              if (state is CategoriaLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Text(
                      'Última actualización: ${DateFormat('dd/MM HH:mm').format(state.timestamp)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refrescar',
            onPressed: () {
              context.read<CategoriaBloc>().add(CategoriaInitEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<CategoriaBloc, CategoriaState>(
        listener: (context, state) {
          if (state is CategoriaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CategoriaCreated) {
            SnackBarHelper.showSnackBar(
                      context,
                      ApiConstantes.categorysuccessCreated,
                      statusCode: 200,
                    );
          } else if (state is CategoriaUpdated) {
             SnackBarHelper.showSnackBar(
                      context,
                      ApiConstantes.categorysuccessUpdated,
                      statusCode: 200,
                    );
          } else if (state is CategoriaDeleted) {
             SnackBarHelper.showSnackBar(
                      context,
                      ApiConstantes.categorysuccessDeleted,
                      statusCode: 200,
                    );
          }
        },
        builder: (context, state) {
          if (state is CategoriaLoading ||
              state is CategoriaCreating ||
              state is CategoriaUpdating ||
              state is CategoriaDeleting) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriaLoaded) {
            final categorias = state.categorias;
            if (categorias.isEmpty) {
              return const Center(
                child: Text('No hay categorías disponibles.'),
              );
            }

            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    leading: _buildCategoryImage(categoria.imagenUrl),
                    title: Text(
                      categoria.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      categoria.descripcion,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar categoría',
                          onPressed: () => _showEditDialog(context, categoria),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar categoría',
                          onPressed:
                              () => _showDeleteDialog(context, categoria),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Cargando categorías...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: 'Agregar categoría',
        child: const Icon(Icons.add),
      ),
    );
  }

   Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: Icon(Icons.category, color: Colors.white),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2.0,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error cargando imagen: $error');
            return const Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 30,
            );
          },
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final categoriaBloc = context.read<CategoriaBloc>();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController imagenUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Agregar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('El nombre es obligatorio')),
                  );
                  return;
                }

                // Enviar evento para crear categoría
                categoriaBloc.add(
                  CategoriaCreateEvent(
                    nombre: nombreController.text,
                    descripcion: descripcionController.text,
                    imagenUrl: imagenUrlController.text,
                  ),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Categoria categoria) {
    final categoriaBloc = context.read<CategoriaBloc>();
    final TextEditingController nombreController = TextEditingController(
      text: categoria.nombre,
    );
    final TextEditingController descripcionController = TextEditingController(
      text: categoria.descripcion,
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: categoria.imagenUrl,
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Editar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('El nombre es obligatorio')),
                  );
                  return;
                }

                // Enviar evento para actualizar categoría
                
                  categoriaBloc.add(
                    CategoriaUpdateEvent(
                      id: categoria.id,
                      nombre: nombreController.text,
                      descripcion: descripcionController.text,
                      imagenUrl: imagenUrlController.text,
                    ),
                  );
                

                Navigator.pop(dialogContext);
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Categoria categoria) {
    final categoriaBloc = context.read<CategoriaBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar Categoría'),
          content: Text(
            '¿Estás seguro de que deseas eliminar la categoría "${categoria.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Enviar evento para eliminar categoría
               
                  categoriaBloc.add(CategoriaDeleteEvent(id: categoria.id));
                

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}