import 'package:flutter/material.dart';

import '../models/pooja_items.dart';

class PoojaItemSearchAnchor extends StatefulWidget {
  final List<PoojaItems> allItems;
  final Function(String) onSearch;
  final Function(PoojaItems) onItemSelected;
  final TextEditingController searchController;

  const PoojaItemSearchAnchor({
    super.key,
    required this.allItems,
    required this.onSearch,
    required this.onItemSelected,
    required this.searchController,
  });

  @override
  State<PoojaItemSearchAnchor> createState() => _PoojaItemSearchAnchorState();
}

class _PoojaItemSearchAnchorState extends State<PoojaItemSearchAnchor> {
  final searchAnchorController = SearchController();

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
            leading: const Icon(Icons.shopping_basket),
            title: Text(item.name!),
            subtitle: Row(
              children: [
                Text(
                  "₹${item.sellingPrice}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                if (item.mrp! > item.sellingPrice!)
                  Text(
                    "₹${item.mrp}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (item.mrp! > item.sellingPrice!)
                  Text(
                    " (${((1 - (item.sellingPrice! / item.mrp!)) * 100).toStringAsFixed(0)}% off)",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red),
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
