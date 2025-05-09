import 'package:flutter/material.dart';

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool ordenAscendente;
  final Function(bool) onOrdenChanged;

  const CommentAppBar({
    super.key,
    required this.ordenAscendente,
    required this.onOrdenChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Comentarios'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Tooltip(
          message: ordenAscendente 
              ? 'Ordenar por más recientes' 
              : 'Ordenar por más antiguos',
          child: IconButton(
            onPressed: () => onOrdenChanged(!ordenAscendente),
            icon: Icon(ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward),
          ),
        ),
      ],
    );
  }
}