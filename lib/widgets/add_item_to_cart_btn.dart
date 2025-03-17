import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class AddItemToCartBtn extends StatelessWidget {
  const AddItemToCartBtn({
    super.key,
    required this.itemId,
    required this.onQuantityChanged,
  });

  final int itemId;
  final Function(int p1, int p2) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.controlHeight,
      child: OutlinedButton(
        onPressed: () => onQuantityChanged(itemId, 1),
        child: Text(
          "ADD",
          style: TextStyle(
            fontSize: context.responsiveFontSize(mobile: 12, desktop: 13),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
