import 'package:abaez/bloc/bloc%20noticias/noticias_event.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:abaez/constants.dart';
import 'package:abaez/views/category_screen.dart';
import 'package:abaez/views/preferencia_screen.dart';
import 'package:abaez/helpers/snackbar_helper.dart';
import 'package:abaez/components/noticia_dialogs.dart';

class NoticiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final bool filtrosActivos;

  const NoticiaAppBar({
    super.key,
    required this.onRefresh,
    required this.filtrosActivos,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticiasBloc, NoticiasState>(
      builder: (context, state) {
        return AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                NoticiaConstantes.tituloApp,
                style: TextStyle(color: Colors.white),
              ),
              if (state is NoticiasLoaded)
                Text(
                  'Última actualización: ${DateFormat(NoticiaConstantes.formatoFecha).format(state.lastUpdated)}',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 248, 174, 206),
          actions: _buildActions(context),
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => _handleAddNoticia(context),
    ),
    IconButton(
      icon: const Icon(Icons.category),
      onPressed:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CategoryScreen()),
          ),
    ),
    IconButton(
      icon: Icon(
        Icons.filter_list,
        color: filtrosActivos ? Colors.amber : null,
      ),
      onPressed: () => _handleFilterPress(context),
    ),
    IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
  ];

  Future<void> _handleAddNoticia(BuildContext context) async {
    try {
      await NoticiaModal.mostrarModal(
        context: context,
        noticia: null,
        onSave: () {
          context.read<NoticiasBloc>().add(const FetchNoticias());
          SnackBarHelper.showSnackBar(
            context,
            ApiConstantes.newssuccessCreated,
          );
        },
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      SnackBarHelper.showSnackBar(
        context,
        'Error al crear noticia',
        statusCode: 400,
      );
    }
  }

  Future<void> _handleFilterPress(BuildContext context) async {
    final categorias = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const PreferenciasScreen()),
    );

    if (!context.mounted) return;

    context.read<NoticiasBloc>().add(
      categorias?.isNotEmpty ?? false
          ? FilterNoticiasByPreferencias(categorias!)
          : const FetchNoticias(),
    );
  }
}
