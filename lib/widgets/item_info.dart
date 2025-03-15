import 'package:flutter/material.dart';

import '../models/pooja_items.dart';
import '../models/pooja_items_units.dart';
import '../utils/pooja_item_utils.dart';

class ItemNameImgUnit extends StatelessWidget {
  const ItemNameImgUnit({
    super.key,
    required this.item,
    required this.useWideLayout,
    required this.pUnits,
  });

  final PoojaItems item;
  final bool useWideLayout;
  final List<PoojaUnits> pUnits;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            child:
                item.img != null
                    ? Image.network(item.img!)
                    : Icon(Icons.shopping_basket_outlined),
          ),
          const SizedBox(width: 8), // Add spacing between image and text
          Expanded(
            // Prevents text overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Avoid unnecessary space
              children: [
                Text(
                  item.name ?? 'Unknown Item',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: useWideLayout ? 14 : 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.unitCount} ${PoojaItemUtils().getUnitName(item.unitId!, pUnits)}",
                  style: TextStyle(
                    fontSize: useWideLayout ? 14 : 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
