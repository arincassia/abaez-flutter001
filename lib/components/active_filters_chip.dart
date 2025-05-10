import 'package:abaez/bloc/bloc%20noticias/noticias_event.dart';
import 'package:abaez/bloc/preferencia/preferencia_event.dart';
import 'package:abaez/bloc/preferencia/preferencia_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abaez/bloc/preferencia/preferencia_bloc.dart';
import 'package:abaez/bloc/bloc%20noticias/noticias_bloc.dart';
import 'package:abaez/helpers/snackbar_helper.dart';

class ActiveFiltersChip extends StatelessWidget {
  const ActiveFiltersChip({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenciaBloc, PreferenciaState>(
      builder: (context, state) {
        if (state.categoriasSeleccionadas.isEmpty) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.grey[300],
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('Filtrado por ${state.categoriasSeleccionadas.length} categorías')),
              InkWell(
                onTap: () => _resetFilters(context),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text('Limpiar filtros', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetFilters(BuildContext context) {
    context.read<PreferenciaBloc>().add(const ReiniciarFiltros());
    context.read<NoticiasBloc>().add(const FetchNoticias());
    SnackBarHelper.showSnackBar(context, 'Filtros reiniciados');
  }
}