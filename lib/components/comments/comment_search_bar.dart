import 'package:abaez/bloc/comentarios/comentario_bloc.dart';
import 'package:abaez/bloc/comentarios/comentario_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSearchBar extends StatelessWidget {
  final TextEditingController busquedaController;
  final VoidCallback onSearch;
  final String noticiaId;

  const CommentSearchBar({
    super.key,
    required this.busquedaController,
    required this.onSearch,
    required this.noticiaId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: busquedaController,
            decoration: InputDecoration(
              hintText: 'Buscar en comentarios...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: busquedaController,
                builder: (context, value, child) {
                  return value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            busquedaController.clear();
                            context.read<ComentarioBloc>()
                              .add(LoadComentarios(noticiaId: noticiaId));
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}