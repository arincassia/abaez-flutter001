import 'package:flutter/material.dart';
import 'package:abaez/domain/noticia.dart';

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComment;
  final VoidCallback onReport;

  const NoticiaCard({
    super.key,
    required this.noticia,
    required this.onEdit,
    required this.onDelete,
    required this.onComment,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(noticia.titulo, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(noticia.descripcion),
            _buildActionRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow() => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(Icons.edit, Colors.blue, onEdit),
        _buildActionButton(Icons.delete, Colors.red, onDelete),
        _buildActionButton(Icons.comment, Colors.green, onComment),
        _buildActionButton(Icons.report, Colors.orange, onReport),
      ],
    ),
  );

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: IconButton(
      icon: Icon(icon, color: color),
      iconSize: 24,
      onPressed: onPressed,
    ),
  );
}