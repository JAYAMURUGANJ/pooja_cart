import 'package:flutter/material.dart';

class ProductFilterSection extends StatefulWidget {
  const ProductFilterSection({super.key});

  @override
  State<ProductFilterSection> createState() => _ProductFilterSectionState();
}

class _ProductFilterSectionState extends State<ProductFilterSection> {
  String _searchQuery = '';
  bool _showActiveOnly = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          // _filterProducts();
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              // _filterProducts();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Show active products only'),
                  value: _showActiveOnly,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _showActiveOnly = value ?? false;
                    });
                    // _filterProducts();
                  },
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.sort),
                label: const Text('Sort'),
                onPressed: () {
                  _showSortOptions();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by name (A-Z)'),
                onTap: () {
                  // setState(() {
                  //   _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
                  // });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by name (Z-A)'),
                onTap: () {
                  // setState(() {
                  //   _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
                  // });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by stock level (Low to High)'),
                onTap: () {
                  // setState(() {
                  //   _filteredProducts.sort((a, b) {
                  //     int aStock = a.units.isEmpty ? 0 : a.units.first.inStock;
                  //     int bStock = b.units.isEmpty ? 0 : b.units.first.inStock;
                  //     return aStock.compareTo(bStock);
                  //   });
                  // });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by stock level (High to Low)'),
                onTap: () {
                  // setState(() {
                  //   _filteredProducts.sort((a, b) {
                  //     int aStock = a.units.isEmpty ? 0 : a.units.first.inStock;
                  //     int bStock = b.units.isEmpty ? 0 : b.units.first.inStock;
                  //     return bStock.compareTo(aStock);
                  //   });
                  // });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by status (Active first)'),
                onTap: () {
                  // setState(() {
                  //   _filteredProducts.sort((a, b) {
                  //     if (a.isActive == b.isActive) {
                  //       return a.name.compareTo(b.name);
                  //     }
                  //     return a.isActive ? -1 : 1;
                  //   });
                  // });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
