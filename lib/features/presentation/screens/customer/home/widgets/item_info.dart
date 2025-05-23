import 'package:flutter/material.dart';
import "package:flutter/src/widgets/image.dart" as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';

import '../../../../../../utils/responsive_utils.dart';
import '../cubit/unit_selection/unit_selection_cubit.dart';

class ItemNameImgUnit extends StatefulWidget {
  const ItemNameImgUnit({
    super.key,
    required this.item,
    required this.pUnits,
    this.useWideLayout,
    required this.unitSelectionCubit,
  });

  final ProductResponse item;
  final bool? useWideLayout;
  final List<ProductResponse> pUnits;
  final UnitSelectionCubit unitSelectionCubit;

  @override
  State<ItemNameImgUnit> createState() => _ItemNameImgUnitState();
}

class _ItemNameImgUnitState extends State<ItemNameImgUnit> {
  UnitSelectionCubit get _unitSelectionCubit => widget.unitSelectionCubit;

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
                  widget.item.images != null && widget.item.images!.isNotEmpty
                      ? ui.Image.network(
                        widget.item.images!.first.imageUrl!,
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
                if (widget.item.categoryId != null)
                  Text(
                    widget.item.categoryId.toString(),
                    // _getCategoryName(widget.item.categoryId!),
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
          _buildUnitSelection(effectiveWideLayout, context, unitFontSize),
        ],
      ),
    );
  }

  Padding _buildUnitSelection(
    bool effectiveWideLayout,
    BuildContext context,
    double unitFontSize,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: effectiveWideLayout ? 8 : 6,
          vertical: effectiveWideLayout ? 4 : 2,
        ),
        width: 80,
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
        child: BlocBuilder<UnitSelectionCubit, UnitSelectionState>(
          bloc: _unitSelectionCubit,
          builder: (context, state) {
            final defaultUnit = widget.item.units!.firstWhere(
              (unit) => unit.isDefault == 1,
              orElse: () => widget.item.units!.first,
            );

            final selectedUnit =
                state.selectedUnits[widget.item.id] ?? defaultUnit;
            return DropdownButton<ProductUnitResponse>(
              isDense: true,
              isExpanded: true,
              underline: const SizedBox(),
              value: selectedUnit,
              items:
                  widget.item.units!.map((unit) {
                    return DropdownMenuItem<ProductUnitResponse>(
                      value: unit,
                      child: Text(
                        "${unit.conversionFactor} ${unit.abbreviation.toString()}",
                        style: GoogleFonts.aBeeZee(
                          fontSize: unitFontSize,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (ProductUnitResponse? selectedUnit) {
                // BlocProvider.of<UnitSelectionCubit>(
                //   context,
                // ).selectUnit(widget.item.id!, selectedUnit!);
                _unitSelectionCubit.selectUnit(widget.item.id!, selectedUnit!);
              },
            );
          },
        ),
      ),
    );
  }
}
