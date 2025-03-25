import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constants/unit.dart';
import '../../../../../models/pooja_items.dart';
import '../../../../../models/pooja_items_units.dart';
import '../../../../../utils/pooja_item_utils.dart';

class ItemSearchAnchor extends StatefulWidget {
  final List<PoojaItems> allItems;
  final Function(String) onSearch;
  final Function(PoojaItems) onItemSelected;
  final TextEditingController searchController;

  const ItemSearchAnchor({
    super.key,
    required this.allItems,
    required this.onSearch,
    required this.onItemSelected,
    required this.searchController,
  });

  @override
  State<ItemSearchAnchor> createState() => _ItemSearchAnchorState();
}

class _ItemSearchAnchorState extends State<ItemSearchAnchor> {
  final searchAnchorController = SearchController();
  final List<PoojaUnits> pUnits = PoojaUnits.fromJsonList(poojaItemUnits);

  List<PoojaItems> _getSuggestions(String query) {
    if (query.isEmpty) {
      return [];
    }
    return widget.allItems
        .where((item) => item.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    searchAnchorController.text = widget.searchController.text;
    searchAnchorController.addListener(() {
      widget.searchController.text = searchAnchorController.text;
      widget.onSearch(searchAnchorController.text);
    });
    widget.searchController.addListener(() {
      if (widget.searchController.text != searchAnchorController.text) {
        searchAnchorController.text = widget.searchController.text;
      }
    });
  }

  @override
  void dispose() {
    searchAnchorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: searchAnchorController,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: "Search Products...",
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                widget.searchController.clear();
                widget.onSearch("");
              },
            ),
          ],
          onChanged: widget.onSearch,
          onSubmitted: widget.onSearch,
          onTap: controller.openView,
          // shape: WidgetStateProperty.all<OutlinedBorder>(
          //   const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.zero, // Removes border radius
          //   ),
          // ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final suggestions = _getSuggestions(controller.text);

        if (suggestions.isEmpty) {
          return [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 70),
                  const SizedBox(height: 20),
                  Text(
                    'No items found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Try adjusting your search or filters',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ];
        }

        return suggestions.map(
          (item) => ListTile(
            leading: ClipOval(
              child:
                  item.img != null && item.img!.isNotEmpty
                      ? Image.network(
                        item.img!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.shopping_basket_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.6),
                          );
                        },
                      )
                      : Icon(
                        Icons.shopping_basket_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                      ),
            ),
            title: Text("${item.name}"),
            subtitle: Row(
              children: [
                Text(
                  "₹${item.sellingPrice}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  "(${item.unitCount}${ProductUtils().getUnitName(item.unitId!, pUnits)})",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: OutlinedButton(
              onPressed: () {
                controller.closeView(item.name);
                widget.onItemSelected(item);
                FocusScope.of(context).unfocus();
              },
              child: const Text("Add"),
            ),
            onTap: () {
              controller.closeView(controller.text);
              widget.onItemSelected(item);
              FocusScope.of(context).unfocus();
            },
          ),
        );
      },
    );
  }
}
