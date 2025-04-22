import 'package:flutter/material.dart';
import 'package:abaez/api/service/noticia_service.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/components/noticia_card.dart';
import 'package:abaez/constans.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  NoticiasScreenState createState() => NoticiasScreenState();
}

class NoticiasScreenState extends State<NoticiasScreen> {
  final NoticiaService noticiaService = NoticiaService(NoticiaRepository());
  final ScrollController _scrollController = ScrollController();

  List<Noticia> noticiasList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool ordenarPorFecha = true;
  String? mensajeError;

  @override
  void initState() {
    super.initState();
    _loadNoticias(reset: true); // Carga inicial de noticias

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore && !isLoading) {
        _loadNoticias(); // Carga paginada al hacer scroll
      }
    });
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
    setState(() {
      mensajeError = 'Error al cargar noticias. Por favor, inténtalo de nuevo.';
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
@override
  Widget build(BuildContext context) {
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
                          return NoticiaCard(noticia: noticia, index: index); //realiza el llamado al card de noticias
                        },
                      ),
                      
               ),
               floatingActionButton: FloatingActionButton(
      onPressed: () => _showAddNoticiaForm(context),
      tooltip: 'Agregar Noticia',
      child: const Icon(Icons.add),
    ),
      );
  }

  void _showAddNoticiaForm(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fuenteController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController imagenUrlController = TextEditingController();

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
                 validator: (value) => validarFecha(value), // Llamar directamente a la función validarFecha
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
      final nuevaNoticia = Noticia(
        id: DateTime.now().toIso8601String(),
        titulo: tituloController.text,
        contenido: descripcionController.text,
        fuente: fuenteController.text,
        publicadaEl: DateTime.now(),
        imagenUrl: imagenUrlController.text.isNotEmpty
            ? imagenUrlController.text
            : null, // Imagen por defecto
      );

      try {
        await noticiaService.crearNoticia(nuevaNoticia);

        if (!context.mounted) return; // Verificar si el widget sigue montado

        setState(() {
          noticiasList.insert(0, nuevaNoticia); // Agregar al inicio de la lista
        });

        Navigator.pop(context); // Cerrar el diálogo
      } catch (e) {
        if (!mounted) return; // Verificar si el widget sigue montado

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
  }
}