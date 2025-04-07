// import 'package:go_router/go_router.dart';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderFailedWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const OrderFailedWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Status'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.red[700],
                ),
              ),

              const SizedBox(height: 24.0),

              // Error Title
              const Text(
                'Order Failed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16.0),

              // Error Message
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Error: $errorMessage',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32.0),

              // Retry Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Back to Cart Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/');
                    html.window.history.pushState(null, '', '/');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Back to Cart',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Customer Support Info
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.support_agent, color: Colors.blue),
                        SizedBox(width: 8.0),
                        Text(
                          'Need Help?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'If the problem persists, please contact our customer support team.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
