import 'package:abaez/data/categorias_repository.dart';
import 'package:flutter/material.dart';

import 'package:abaez/domain/categoria.dart';
import 'package:abaez/constantes/constants.dart';
import 'package:abaez/exceptions/api_exception.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  CategoriasScreenState createState() => CategoriasScreenState();
}

class CategoriasScreenState extends State<CategoriasScreen> {
final CategoriaRepository categoriaService = CategoriaRepository();
  List<Categoria> categoriasList = [];
  bool isLoading = false;
  String? mensajeError;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    setState(() {
      isLoading = true;
      mensajeError = null;
    });

    try {
      final categorias = await categoriaService.listarCategoriasDesdeAPI();
      if (!mounted) return;

      setState(() {
        categoriasList = categorias;
      });
    } catch (e) {
      debugPrint('Error al cargar categorías: $e');
      if (!mounted) return;

      setState(() {
        mensajeError = 'Error al cargar categorías. Por favor, inténtalo de nuevo.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showAddCategoriaForm(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imagenUrlController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Categoría'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final nuevaCategoria = Categoria(
                  id: '', // El ID será generado por el servidor
                  nombre: nameController.text,
                  descripcion: descriptionController.text,
                  imagenUrl: imagenUrlController.text.isNotEmpty
                      ? imagenUrlController.text
                      : null, // Imagen por defecto
                );

                try {
                  await categoriaService.crearCategoria(nuevaCategoria);

                  if (!context.mounted) return;

                  Navigator.pop(context); // Cerrar el diálogo
                  _loadCategorias();
                  if (!context.mounted) return;
                  SnackBarHelper.showSnackBar(
                    context,
                    ApiConstants.categorysuccessCreated,
                    statusCode: 200, // Código de éxito
                  );
                } catch (e) {
                  debugPrint('Error al crear categoría: $e');
                  final statusCode = e is ApiException ? e.statusCode : null;
                  SnackBarHelper.showSnackBar(
                    context,
                    'Error al crear categoría: $e',
                    statusCode: statusCode,
                  );
                }
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}

  void _showEditCategoriaForm(BuildContext context, Categoria categoria) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: categoria.nombre);
  final TextEditingController descriptionController = TextEditingController(text: categoria.descripcion);
  final TextEditingController imagenUrlController = TextEditingController(text: categoria.imagenUrl ?? '');

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar Categoría'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final categoriaEditada = Categoria(
                  id: categoria.id,
                  nombre: nameController.text,
                  descripcion: descriptionController.text,
                  imagenUrl: imagenUrlController.text.isNotEmpty
                      ? imagenUrlController.text
                      : null, // Imagen por defecto
                );

                try {
                  await categoriaService.editarCategoria(categoriaEditada);

                  if (!context.mounted) return;

                  Navigator.pop(context); // Cerrar el diálogo
                  _loadCategorias();
                  if (!context.mounted) return;
                  SnackBarHelper.showSnackBar(
                    context,
                    ApiConstants.categorysuccessUpdated, // Mensaje de éxito
                    statusCode: 200, // Código de éxito
                  );
                } catch (e) {
                  debugPrint('Error al editar categoría: $e');
                  final statusCode = e is ApiException ? e.statusCode : null;
                  SnackBarHelper.showSnackBar(
                    context,
                    'Error al editar categoría: $e', // Mensaje de error
                    statusCode: statusCode,
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}
  void _deleteCategoria(Categoria categoria) async {
    try {
      await categoriaService.eliminarCategoria(categoria.id);

      if (!mounted) return;

      _loadCategorias();

       SnackBarHelper.showSnackBar(
      context,
      ApiConstants.categorysuccessDeleted, // Mensaje de éxito
      statusCode: 200, // Código de éxito
    );
  } catch (e) {
    debugPrint('Error al eliminar categoría: $e');
    final statusCode = e is ApiException ? e.statusCode : null;
    SnackBarHelper.showSnackBar(
      context,
      'Error al eliminar categoría: $e', // Mensaje de error
      statusCode: statusCode,
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : mensajeError != null
              ? Center(
                  child: Text(
                    mensajeError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: categoriasList.length,
                  itemBuilder: (context, index) {
                    final categoria = categoriasList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: categoria.imagenUrl != null && categoria.imagenUrl!.isNotEmpty
                            ? Image.network(
                                categoria.imagenUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50); // Icono si la imagen falla
                                },
                              )
                            : const Icon(Icons.image, size: 50), // Icono predeterminado si no hay imagen
                        title: Text(categoria.nombre),
                        subtitle: Text(categoria.descripcion),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditCategoriaForm(context, categoria),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCategoria(categoria),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoriaForm(context),
        tooltip: 'Agregar Categoría',
        child: const Icon(Icons.add),
      ),
    );
  }
}