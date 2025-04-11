import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget subtitle;
  final Widget trailing;

  const BaseCard({
    super.key, // Usa super parameter para 'key'
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}