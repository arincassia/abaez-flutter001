import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/api/service/categoria_service.dart';
class NoticiaModal {  static Future<void> mostrarModal({
    required BuildContext context,
    Map<String, dynamic>? noticia, // Datos de la noticia para editar
    required Function(Map<String, dynamic>? noticia, Map<String, dynamic> noticiaActualizada) onSave, // Callback para guardar con noticia actualizada
  }) async {
    final formKey = GlobalKey<FormState>();
    final NoticiaRepository noticiaService = NoticiaRepository();

    // Controladores para los campos del formulario
    final TextEditingController tituloController = TextEditingController(
      text: noticia?['titulo'] ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: noticia?['descripcion'] ?? '',
    );
    final TextEditingController fuenteController = TextEditingController(
      text: noticia?['fuente'] ?? '',
    );
    final TextEditingController fechaController = TextEditingController(
      text: noticia?['publicadaEl'] ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: noticia?['urlImagen'] ?? '',
    );

    DateTime? fechaSeleccionada =
        noticia != null ? DateTime.tryParse(noticia['publicadaEl'] ?? '') : null;

    String? categoriaSeleccionada = noticia?['categoriaId'];

    List<Categoria> categorias = [];
    try {
      final categoriaRepository = CategoriaService();
      categorias = await categoriaRepository.getCategorias();
      // Añadir la opción "Sin categoría" al inicio de la lista
      categorias.insert(0, Categoria(id: '', nombre: 'Sin categoría', descripcion: 'Sin categoría'));

      // Verificar si la categoría seleccionada existe en las opciones
      if (categoriaSeleccionada != null) {
        bool existeCategoria = categorias.any((c) => c.id == categoriaSeleccionada);
        if (!existeCategoria) {
          // Si no existe, establecer como null para que se seleccione la primera
          categoriaSeleccionada = null;
        }
      }
    } catch (e) {
      // Manejo de errores al cargar categorías
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }

    Future<void> guardarNoticia() async {
      if (formKey.currentState!.validate()) {
        try {
          // Convierte la fecha seleccionada al formato ISO 8601

          if (noticia == null) {
            // Crear nueva noticia
            await noticiaService.crearNoticia(
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
              publicadaEl: fechaSeleccionada ?? DateTime.now(),
              urlImagen: imagenUrlController.text,
              categoriaId: categoriaSeleccionada ?? CategoriaConstantes.defaultcategoriaId,
            );
          } else {
            // Editar noticia existente
            await noticiaService.actualizarNoticia(
              id: noticia['id'],
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
               publicadaEl: fechaSeleccionada ?? DateTime.now(),
              urlImagen: imagenUrlController.text,
              categoriaId: categoriaSeleccionada ?? CategoriaConstantes.defaultcategoriaId,
            );
          }

          // Muestra un mensaje de éxito
             // Crea un map con los datos actualizados de la noticia
          final noticiaActualizada = {
            'id': noticia?['id'],
            'titulo': tituloController.text,
            'descripcion': descripcionController.text,
            'fuente': fuenteController.text,
            'publicadaEl': (fechaSeleccionada ?? DateTime.now()).toIso8601String(),
            'urlImagen': imagenUrlController.text,
            'categoriaId': categoriaSeleccionada ?? CategoriaConstantes.defaultcategoriaId,
          };
          
          // Llama al callback para actualizar la lista de noticias
          onSave(noticia, noticiaActualizada);

          // Cierra el modal
          if (!context.mounted) return;
          Navigator.pop(context);
        } catch (e) {
          // Muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la noticia: $e')),
          );
        }
      }
    }
     if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(noticia == null ? 'Crear Noticia' : 'Editar Noticia'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una fuente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de publicación',
                      hintText: 'Seleccionar Fecha',
                    ),
                    onTap: () async {
                      DateTime? nuevaFecha = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (nuevaFecha != null) {
                        fechaSeleccionada = nuevaFecha;
                        fechaController.text = DateFormat(
                          'dd-MM-yyyy',
                        ).format(nuevaFecha); // Formatea la fecha
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una fecha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una URL de imagen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  
                  DropdownButtonFormField<String>(
                    value: categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      categoriaSeleccionada = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona una categoría';
                      }
                      return null;
                    },
                    // Añadir opción de placeholder cuando no hay selección
                    hint: const Text('Selecciona una categoría'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: guardarNoticia,
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
