import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: context.responsiveIconSize,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your order is empty',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
