import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abaez/constants.dart';

class LastUpdatedHeader extends StatelessWidget {
  final DateTime? lastUpdated;
  
  const LastUpdatedHeader({
    super.key,
    this.lastUpdated,
  });
  
  @override
  Widget build(BuildContext context) {
    if (lastUpdated == null) return const SizedBox.shrink();
    
    final String formattedDate = DateFormat(AppConstants.formatoFecha).format(lastUpdated!);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Text(
        'Última actualización: $formattedDate',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}