import 'package:flutter/material.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/components/noticia_card.dart';
import 'package:abaez/constantes/constants.dart';
import 'package:abaez/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:abaez/helpers/api_error_helper.dart';
import 'package:abaez/exceptions/api_exception.dart';

import 'package:abaez/api/service/categoria_service.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/domain/categoria.dart';
import 'package:abaez/views/categorias_screen_dos.dart';

//import 'package:abaez/views/categorias_screen.dart';
class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  NoticiasScreenState createState() => NoticiasScreenState();
}

class NoticiasScreenState extends State<NoticiasScreen> {
final NoticiaRepository noticiaService = NoticiaRepository(NoticiaService());  
final ScrollController _scrollController = ScrollController();

  List<Noticia> noticiasList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool ordenarPorFecha = true;
  String? mensajeError;

  @override
  void initState() {
    print('NoticiasScreenState initState() llamado'); // Mensaje de depuración
    super.initState();
    _loadNoticias(reset: true); // Carga inicial de noticias

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore && !isLoading) {
        _loadNoticias(); // Carga paginada al hacer scroll
      }
    });
  }
void _mostrarSnackBarError(BuildContext context, ApiException exception) {
  final errorDetails = getErrorDetails(exception);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorDetails.message),
      backgroundColor: errorDetails.color,
      duration: const Duration(seconds: 3),
    ),
  );
}


Future<void> _loadNoticias({bool reset = false}) async {
  if (isLoading) return;

  setState(() {
    isLoading = true;
    mensajeError = null;
    if (reset) {
      noticiasList.clear();
      currentPage = 1;
      hasMore = true;
    }
  });

  try {
    final newNoticias = await noticiaService.listarNoticiasDesdeAPI();

    if (!mounted) return; // Verificar si el widget sigue montado

    setState(() {
      if (newNoticias.isEmpty) {
        hasMore = false; // No hay más noticias para cargar
      } else {
        noticiasList.addAll(newNoticias); // Agregar todas las noticias
        currentPage++;
      }
    });
  } catch (e) {
    debugPrint('Error al cargar noticias: $e');

    if (!mounted) return; // Verificar si el widget sigue montado

    setState(() {
      mensajeError = 'Error al cargar noticias. Por favor, inténtalo de nuevo.';
    });

    // Mostrar SnackBar con el mensaje de error
    if (e is DioException) {
  if (mounted) {
    final apiException = ApiException(
      e.message ?? 'Error desconocido',
      statusCode: e.response?.statusCode,
    );
    _mostrarSnackBarError(context, apiException);
  }
} else {
  if (mounted) {
    final apiException = ApiException('Error desconocido');
    _mostrarSnackBarError(context, apiException);
  }
}
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}


@override
  Widget build(BuildContext context) {
      print('NoticiasScreenState build() llamado');
    return Scaffold(
    appBar: AppBar(
  title: const Text(AppConstants.tituloNoticias),
  actions: [
    IconButton(
      icon: const Icon(Icons.sort),
      tooltip: 'Cambiar orden',
      onPressed: () {
        setState(() {
          ordenarPorFecha = !ordenarPorFecha;
          _loadNoticias(reset: true); // Reinicia la lista con el nuevo criterio
        });
      },
    ),
    IconButton(
  icon: const Icon(Icons.category),
  tooltip: 'Categorías',
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoriaScreenDos(),
      ),
    ); // Navegar directamente a CategoriasScreen
  },
),
  ],
),

      body: Container(
        
        color: Colors.grey[200],
        child: isLoading && noticiasList.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(AppConstants.mensajeCargando),
                  ],
                ),
              )
            : mensajeError != null
                ? Center(
                    child: Text(
                      mensajeError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : noticiasList.isEmpty
                    ? const Center(
                        child: Text(
                          AppConstants.listasVacia,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
               : ListView.builder(
  controller: _scrollController,
  itemCount: noticiasList.length + (isLoading ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == noticiasList.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final noticia = noticiasList[index];

    return NoticiaCard(
      noticia: noticia,
      index: index,
      categoriaNombre: (noticia.categoriaId ?? '').isEmpty
    ? 'Sin categoría'
    : noticia.categoriaId!,
      onEdit: () => showEditNoticiaForm(context, noticia, index),
      onDelete: () async {
  try {
    await noticiaService.eliminarNoticia(noticia); // Llama al método del servicio
    if (!context.mounted) return;

    setState(() {
      noticiasList.removeAt(index); // Elimina la noticia de la lista local
    });
    _loadNoticias(reset: true);
     SnackBarHelper.showSnackBar(
    context,
    ApiConstants.newssuccessDeleted,
    statusCode: 200, // Código de éxito
  );


    if (context.mounted){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(ApiConstants.newssuccessDeleted)),
    );
    }
  } catch (e) {
      if (context.mounted){
       debugPrint('Error al eliminar noticia: $e');
  final statusCode = e is ApiException ? e.statusCode : null;
  SnackBarHelper.showSnackBar(
    context,
    'Error al eliminar noticia: $e',
    statusCode: statusCode,
  );
  }
  }
  
},
    );
  },
),                 
               ),
               floatingActionButton: FloatingActionButton(
      onPressed: () => _showAddNoticiaForm(context),
      tooltip: 'Agregar Noticia',
      child: const Icon(Icons.add),
    ),
      // Mensaje de depuración
      );
     
  }

  @protected
  void didupdateWidget(NoticiasScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('NoticiasScreenState didUpdateWidget() llamado'); // Mensaje de depuración
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('NoticiasScreenState didChangeDependencies() llamado'); // Mensaje de depuración
  }


void _showAddNoticiaForm(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fuenteController = TextEditingController();
  final TextEditingController fechaController = TextEditingController(
    text: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', 
  );
  final TextEditingController imagenUrlController = TextEditingController();

  List<Categoria> categorias = [];
  String? categoriaSeleccionada;

  try {
    final categoriaService = CategoriaService();
    categorias = await categoriaService.listarCategoriasDesdeAPI();
     // Agregar la opción "Sin categoría" al inicio de la lista
    categorias.insert(0, Categoria(id: '', nombre: 'Sin categoría', descripcion: 'Sin categoría'));
  } catch (e) {
    debugPrint('Error al cargar categorías: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }
    return;
  }

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar Noticia'),
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
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha (DD/MM/YYYY)'),
                  validator: (value) => validarFecha(value), // Validar la fecha ingresada
                ),
                TextFormField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
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
                  // Eliminamos la validación para que no sea obligatoria
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
                // Combina la fecha ingresada con la hora actual
                final nuevaFecha = convertirFecha(fechaController.text);
                final fechaConHoraActual = DateTime(
                  nuevaFecha.year,
                  nuevaFecha.month,
                  nuevaFecha.day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second,
                );

                final nuevaNoticia = Noticia(
                  id: DateTime.now().toIso8601String(),
                  titulo: tituloController.text,
                  contenido: descripcionController.text,
                  fuente: fuenteController.text,
                  publicadaEl: fechaConHoraActual, // Fecha con la hora actual
                  imagenUrl: imagenUrlController.text.isNotEmpty
                      ? imagenUrlController.text
                      : null, // Imagen por defecto
                  categoriaId: categoriaSeleccionada, // Puede ser null
                );

                try {
                  await noticiaService.crearNoticia(nuevaNoticia);

                  if (!context.mounted) return; // Verificar si el widget sigue montado

                  setState(() {
                    noticiasList.insert(0, nuevaNoticia); // Agregar al inicio de la lista
                  });

                  Navigator.pop(context); // Cerrar el diálogo

                  _loadNoticias(reset: true);

                   SnackBarHelper.showSnackBar(
                   context,
                   ApiConstants.newssuccessCreated,
                   statusCode: 200, // Código de éxito
                  );
                } catch (e) {
                  if (!mounted) return; // Verificar si el widget sigue montado
                    debugPrint('Error al crear noticia: $e');
                    final statusCode = e is ApiException ? e.statusCode : null;
                     SnackBarHelper.showSnackBar(
                      context,
                      'Error al crear noticia: $e',
                      statusCode: statusCode,
                    );

                  debugPrint('Error al crear noticia: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al crear noticia: $e')),
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
  
void showEditNoticiaForm(BuildContext context, Noticia noticia, int index) async {
  final formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController(text: noticia.titulo);
  final TextEditingController descripcionController = TextEditingController(text: noticia.contenido);
  final TextEditingController fuenteController = TextEditingController(text: noticia.fuente);
  final TextEditingController fechaController = TextEditingController(
    text: '${noticia.publicadaEl.day}/${noticia.publicadaEl.month}/${noticia.publicadaEl.year}',
  );
  final TextEditingController imagenUrlController = TextEditingController(text: noticia.imagenUrl ?? '');

  List<Categoria> categorias = [];
  String? categoriaSeleccionada = noticia.categoriaId;

  try {
    final categoriaService = CategoriaService();
    categorias = await categoriaService.listarCategoriasDesdeAPI();

    // Agregar la opción "Sin categoría" al inicio de la lista
    categorias.insert(0, Categoria(id: '', nombre: 'Sin categoría', descripcion: 'Sin categoría'));
  } catch (e) {
    debugPrint('Error al cargar categorías: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }
    return;
  }

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar Noticia'),
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
                      return 'El título es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fuente es obligatoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fechaController,
                  decoration: const InputDecoration(labelText: 'Fecha (DD/MM/YYYY)'),
                  validator: (value) => validarFecha(value),
                ),
                TextFormField(
                  controller: imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                ),
                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada ?? '', // Asegurar que no sea null
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
                final nuevaFecha = convertirFecha(fechaController.text);
                final fechaConHoraActual = DateTime(
                  nuevaFecha.year,
                  nuevaFecha.month,
                  nuevaFecha.day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second,
                );

                final noticiaEditada = Noticia(
                  id: noticia.id,
                  titulo: tituloController.text,
                  contenido: descripcionController.text,
                  fuente: fuenteController.text,
                  publicadaEl: fechaConHoraActual,
                  imagenUrl: imagenUrlController.text.isNotEmpty
                      ? imagenUrlController.text
                      : null,
                  categoriaId: categoriaSeleccionada, // Actualizar la categoría
                );

                try {
                  await noticiaService.editarNoticia(noticiaEditada);


                  if (!context.mounted) return;

                  setState(() {
                    noticiasList[index] = noticiaEditada;
                  });

                  Navigator.pop(context); // Cerrar el diálogo
                  _loadNoticias(reset: true);
                SnackBarHelper.showSnackBar(
                  context,
                 ApiConstants.newssuccessUpdated,
                   statusCode: 200, 
  );
                } catch (e) {
                  if (!mounted) return;
                    debugPrint('Error al editar noticia: $e');
                    final statusCode = e is ApiException ? e.statusCode : null;
                    SnackBarHelper.showSnackBar(
                     context,
                     'Error al editar noticia: $e',
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
String? validarFecha(String? value) {
  if (value == null || value.isEmpty) {
    return 'La fecha es obligatoria';
  }

  final partes = value.split('/');
  if (partes.length != 3) {
    return 'El formato de la fecha debe ser DD/MM/YYYY';
  }

  final dia = int.tryParse(partes[0]);
  final mes = int.tryParse(partes[1]);
  final anio = int.tryParse(partes[2]);

  if (dia == null || mes == null || anio == null) {
    return 'La fecha contiene valores no válidos';
  }

  try {
    DateTime(anio, mes, dia); // Verifica si la fecha es válida
  } catch (e) {
    return 'La fecha no es válida';
  }

  return null; // La fecha es válida
}

DateTime convertirFecha(String value) {
  final partes = value.split('/');
  final dia = int.parse(partes[0]);
  final mes = int.parse(partes[1]);
  final anio = int.parse(partes[2]);
  return DateTime(anio, mes, dia);
}
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    print('NoticiasScreenState dispose() llamado'); // Mensaje de depuración
  }

  @override
  void deactivate() {
    super.deactivate();
    print('NoticiasScreenState deactivate() llamado'); // Mensaje de depuración
  }
}