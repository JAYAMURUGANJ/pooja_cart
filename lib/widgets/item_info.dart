import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/category.dart';
import '../models/pooja_item_category.dart';
import '../models/pooja_items.dart';
import '../models/pooja_items_units.dart';
import '../utils/pooja_item_utils.dart';

class ItemNameImgUnit extends StatefulWidget {
  const ItemNameImgUnit({
    super.key,
    required this.item,
    required this.pUnits,
    this.useWideLayout,
  });

  final PoojaItems item;
  final bool? useWideLayout;
  final List<PoojaUnits> pUnits;

  @override
  State<ItemNameImgUnit> createState() => _ItemNameImgUnitState();
}

class _ItemNameImgUnitState extends State<ItemNameImgUnit> {
  final List<PoojaItemCategory> pCategories = PoojaItemCategory.fromJsonList(
    poojaItemCategory,
  );

  // Helper method to get category name from category ID
  String _getCategoryName(int categoryId) {
    final category = pCategories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => PoojaItemCategory(id: categoryId, name: "Category"),
    );
    return category.name ?? "Category";
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final bool effectiveWideLayout =
        widget.useWideLayout ?? (screenWidth > 600);

    // Responsive dimensions
    final double imageSize = effectiveWideLayout ? 50 : 45;
    final double nameFontSize = effectiveWideLayout ? 15 : 14;
    final double categoryFontSize = effectiveWideLayout ? 13 : 12;
    final double unitFontSize = effectiveWideLayout ? 13 : 12;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with enhanced styling - aligned to top
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child:
                  widget.item.img != null && widget.item.img!.isNotEmpty
                      ? Image.network(
                        widget.item.img!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.shopping_basket_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.6),
                            size: imageSize * 0.6,
                          );
                        },
                      )
                      : Icon(
                        Icons.shopping_basket_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                        size: imageSize * 0.6,
                      ),
            ),
          ),
          // Perfect spacing between image and content
          SizedBox(width: effectiveWideLayout ? 6 : 4),
          // Text content - top aligned
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.item.name ?? 'Unknown Item',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: nameFontSize,
                    color: Theme.of(context).colorScheme.onSurface,
                    height:
                        1.2, // Tighter line height for better text alignment
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: effectiveWideLayout ? 6 : 4),

                // Category tag with enhanced styling
                if (widget.item.itemCategoryId != null)
                  Text(
                    _getCategoryName(widget.item.itemCategoryId!),
                    style: TextStyle(
                      fontSize: categoryFontSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          // Perfect spacing between content and unit
          SizedBox(width: effectiveWideLayout ? 6 : 0),
          // Unit display - top aligned
          Padding(
            padding: EdgeInsets.only(
              top: 2,
            ), // Slight adjustment to align with text
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: effectiveWideLayout ? 8 : 6,
                vertical: effectiveWideLayout ? 4 : 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                "${widget.item.unitCount}${PoojaItemUtils().getUnitName(widget.item.unitId!, widget.pUnits)}",
                style: GoogleFonts.aBeeZee(
                  fontSize: unitFontSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
