import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/noticias_bloc.dart';
import 'package:abaez/bloc/event/noticias_event.dart';
import 'package:abaez/bloc/state/noticias_state.dart';
import 'package:abaez/data/noticia_repository.dart';
import 'package:abaez/api/service/noticia_sevice.dart';
import 'package:abaez/components/noticia_card.dart';
import 'package:abaez/domain/noticia.dart';
//import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/constantes/constants.dart';
import 'package:abaez/views/categorias_screen.dart';
import 'package:abaez/api/service/categoria_service.dart';
import 'package:abaez/domain/categoria.dart';

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return BlocProvider(
  create: (context) => NoticiasBloc(NoticiaRepository(NoticiaService()))..add(CargarNoticiasEvent()),
  child: Scaffold(
    appBar: AppBar(
      title: const Text(AppConstants.tituloNoticias),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort),
          tooltip: 'Cambiar orden',
          onPressed: () {
            // Implementar lógica para cambiar el orden
          },
        ),
        IconButton(
          icon: const Icon(Icons.category),
          tooltip: 'Categorías',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoriasScreen(),
              ),
            );
          },
        ),
      ],
    ),
    body: BlocBuilder<NoticiasBloc, NoticiasState>(
      builder: (context, state) {
        if (state is NoticiasInicioState || state is NoticiasCargandoState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NoticiasCargadasState) {
          final noticias = state.noticias;
          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];
              return NoticiaCard(
                noticia: noticia,
                index: index,
                categoriaNombre: noticia.categoriaId ?? 'Sin categoría',
                onEdit: () => _showEditNoticiaForm(context, noticia),
                onDelete: () {
                  context.read<NoticiasBloc>().add(EliminarNoticiaEvent(noticia));
                },
              );
            },
          );
        } else if (state is NoticiasErrorState) {
          return Center(child: Text(state.mensaje));
        }
        return const Center(child: Text(AppConstants.listasVacia));
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showAddNoticiaForm(context),
      tooltip: 'Agregar Noticia',
      child: const Icon(Icons.add),
    ),
  ),
);
  }

  void _showAddNoticiaForm(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final fuenteController = TextEditingController();
  final fechaController = TextEditingController(
    text: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
  );
  final imagenUrlController = TextEditingController();

  List<Categoria> categorias = [];
  String? categoriaSeleccionada;

  try {
    final categoriaService = CategoriaService();
    categorias = await categoriaService.listarCategoriasDesdeAPI();
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
    builder: (dialogContext) {
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
                  validator: (value) => value == null || value.isEmpty ? 'El título es obligatorio' : null,
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) => value == null || value.isEmpty ? 'La descripción es obligatoria' : null,
                ),
                TextFormField(
                  controller: fuenteController,
                  decoration: const InputDecoration(labelText: 'Fuente'),
                  validator: (value) => value == null || value.isEmpty ? 'La fuente es obligatoria' : null,
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
              if (formKey.currentState!.validate()) {
                final nuevaNoticia = Noticia(
                  id: DateTime.now().toIso8601String(),
                  titulo: tituloController.text,
                  contenido: descripcionController.text,
                  fuente: fuenteController.text,
                  publicadaEl: convertirFecha(fechaController.text),
                  imagenUrl: imagenUrlController.text.isNotEmpty ? imagenUrlController.text : null,
                  categoriaId: categoriaSeleccionada,
                );
                // Usar el contexto del BlocProvider
                BlocProvider.of<NoticiasBloc>(context).add(AgregarNoticiaEvent(nuevaNoticia));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}

  void _showEditNoticiaForm(BuildContext context, Noticia noticia) {
    // Similar a _showAddNoticiaForm, pero precarga los datos de la noticia
    // y envía un evento EditarNoticiaEvent al Bloc.
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
      DateTime(anio, mes, dia);
    } catch (e) {
      return 'La fecha no es válida';
    }

    return null;
  }

  DateTime convertirFecha(String value) {
    final partes = value.split('/');
    final dia = int.parse(partes[0]);
    final mes = int.parse(partes[1]);
    final anio = int.parse(partes[2]);
    return DateTime(anio, mes, dia);
  }
}