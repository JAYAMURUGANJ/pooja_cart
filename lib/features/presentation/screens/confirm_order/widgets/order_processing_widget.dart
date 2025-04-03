import 'package:flutter/material.dart';

class OrderProcessingWidget extends StatefulWidget {
  final String message;

  const OrderProcessingWidget({
    super.key,
    this.message = "Processing your order. Please wait...",
  });

  @override
  State<OrderProcessingWidget> createState() => _OrderProcessingWidgetState();
}

class _OrderProcessingWidgetState extends State<OrderProcessingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent going back while processing
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or App Icon (optional)
                  // Image.asset('assets/logo.png', height: 80),
                  const SizedBox(height: 40),

                  // Loading Animation
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: null, // Indeterminate
                              strokeWidth: 6.0,
                              color: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Processing Message
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Warning
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber[800],
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Don't refresh the page or press back. This may result in duplicate orders.",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Animated Dots
                  _buildAnimatedDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final isAnimated = (_animationController.value + delay) % 1.0 < 0.5;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color:
                    isAnimated
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
