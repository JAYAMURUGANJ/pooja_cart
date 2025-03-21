import 'package:flutter/material.dart';

import '../../../../../utils/responsive_utils.dart';

class QuantityController extends StatelessWidget {
  const QuantityController({
    super.key,
    required this.itemId,
    required this.quantity,
    required this.onQuantityChanged,
    this.height = 32.0,
    required this.width,
  });

  final int itemId;
  final int quantity;
  final Function(int p1, int p2) onQuantityChanged;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final double quantityWidth = 32.0;

    final double iconButtonWidth = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 12,
      desktop: 13,
    );

    final double fontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 10,
      desktop: 11,
    );

    return Container(
      height: height,
      constraints: BoxConstraints(maxWidth: width ?? double.infinity),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconButtonWidth,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, -1),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.remove,
                  size: fontSize.toDouble(),
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Container(
            width: quantityWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.shade300),
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: fontSize.toDouble(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: iconButtonWidth,
            height: height,
            child: InkWell(
              onTap: () => onQuantityChanged(itemId, 1),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.add,
                  size: fontSize.toDouble(),
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
