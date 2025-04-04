import 'package:flutter/material.dart';

class OrderErrorCard extends StatelessWidget {
  final String? errorMsg;
  const OrderErrorCard({super.key, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32.0),
          const SizedBox(height: 8.0),
          Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.red[800],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            errorMsg ??
                'An error occurred while fetching your orders. Please try again later.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
