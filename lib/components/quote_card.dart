import 'package:flutter/material.dart';
import 'package:abaez/domain/quote.dart';
import 'package:abaez/constans.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final double spacingHeight;

  const QuoteCard({
    super.key,
    required this.quote,
    this.spacingHeight = 10,
  });

  String _formatDate(DateTime date) {
    
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8), 
            border: Border.all(color: Colors.grey.shade300),
          
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote.companyName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppConstants.stockPrice} \$${quote.stockPrice.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              Text(
                '${AppConstants.changePercentage} ${quote.changePercentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: quote.changePercentage >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppConstants.lastUpdated} ${_formatDate(quote.lastUpdated)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(height: spacingHeight), 
      ],
    );
  }
}