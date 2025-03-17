import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/category.dart';
import '../models/pooja_item_category.dart';
import '../models/pooja_items.dart';
import '../models/pooja_items_units.dart';
import '../utils/pooja_item_utils.dart';
import '../utils/responsive_utils.dart';

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

  String _getCategoryName(int categoryId) {
    final category = pCategories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => PoojaItemCategory(id: categoryId, name: "Category"),
    );
    return category.name ?? "Category";
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveWideLayout =
        widget.useWideLayout ?? ResponsiveUtils.isDesktop(context);

    final double imageSize = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 45,
      desktop: 50,
    );

    final double nameFontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 12,
      desktop: 13,
    );

    final double categoryFontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 10,
      desktop: 11,
    );

    final double unitFontSize = ResponsiveUtils.responsiveFontSize(
      context,
      mobile: 10,
      desktop: 11,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(width: effectiveWideLayout ? 6 : 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.item.name ?? 'Unknown Item',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: nameFontSize,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: effectiveWideLayout ? 6 : 4),
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
          SizedBox(width: effectiveWideLayout ? 6 : 0),
          Padding(
            padding: const EdgeInsets.only(top: 2),
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
