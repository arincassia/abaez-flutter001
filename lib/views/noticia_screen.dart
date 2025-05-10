/*import 'package:abaez/bloc/bloc%20noticias/noticias_event.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_state.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/components/noticia_app_bar.dart';
import 'package:abaez/components/active_filters_chip.dart';
import 'package:abaez/helpers/noticia_state_handler.dart';

class NoticiaScreen extends StatelessWidget {
  const NoticiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NoticiasBloc()..add(const FetchNoticias())),
        BlocProvider(
          create: (_) => PreferenciaBloc()..add(const CargarPreferencias()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: NoticiaAppBar(
          onRefresh: () => _handleRefresh(context),
          filtrosActivos:
              context
                  .watch<PreferenciaBloc>()
                  .state
                  .categoriasSeleccionadas
                  .isNotEmpty,
        ),
        body: Column(
          children: [
            const ActiveFiltersChip(),
            Expanded(
              child: BlocBuilder<NoticiasBloc, NoticiasState>(
                builder:
                    (context, state) => NoticiaStateHandler.handleState(
                      context, // Añade el contexto
                      state,
                      onEdit: (noticia) => _handleEditNoticia(context, noticia),
                      onDelete: (noticia) => _handleDeleteNoticia(noticia),
                      onComment:
                          (noticia) => _handleCommentNoticia(context, noticia),
                      onReport: (noticia) => _handleReportNoticia(noticia),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRefresh(BuildContext context) {
    final bloc = context.read<NoticiasBloc>();
    final categorias =
        context.read<PreferenciaBloc>().state.categoriasSeleccionadas;
    categorias.isNotEmpty
        ? bloc.add(FilterNoticiasByPreferencias(categorias))
        : bloc.add(const FetchNoticias());
  }
}
*/