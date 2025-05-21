import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Product {
  final int id;
  final bool isActive;
  final int categoryId;
  final String name;
  final List<ProductUnit> units;
  final List<String> images;

  Product({
    required this.id,
    required this.isActive,
    required this.categoryId,
    required this.name,
    required this.units,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      isActive: json['is_active'] == 1,
      categoryId: json['category_id'],
      name: json['name'],
      units: (json['units'] as List)
          .map((unit) => ProductUnit.fromJson(unit))
          .toList(),
      images: (json['images'] as List).map((e) => e.toString()).toList(),
    );
  }
}

class ProductUnit {
  final int unitId;
  final double conversionFactor;
  final double mrp;
  final double sellingPrice;
  final bool? isDefault;
  final int inStock;
  final String name;
  final String abbreviation;

  ProductUnit({
    required this.unitId,
    required this.conversionFactor,
    required this.mrp,
    required this.sellingPrice,
    this.isDefault,
    required this.inStock,
    required this.name,
    required this.abbreviation,
  });

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      unitId: json['unit_id'],
      conversionFactor: json['conversion_factor'].toDouble(),
      mrp: json['mrp'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
      isDefault: json['is_default'] == 1 ? true : null,
      inStock: json['in_stock'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }
}

class StockMaintenancePage extends StatefulWidget {
  const StockMaintenancePage({Key? key}) : super(key: key);

  @override
  State<StockMaintenancePage> createState() => _StockMaintenancePageState();
}

class _StockMaintenancePageState extends State<StockMaintenancePage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _showActiveOnly = false;
  
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  void _loadProducts() async {
    // In a real app, this would fetch from an API
    // For demo purposes, we'll use the provided JSON
    final String jsonData = '''
[{"id":21,"is_active":1,"category_id":2,"name":"doc","units":[{"unit_id":2,"conversion_factor":500,"mrp":150,"selling_price":45,"is_default":null,"in_stock":54,"name":"Gram","abbreviation":"g"}],"images":[]},{"id":26,"is_active":0,"category_id":2,"name":"Ghee","units":[{"unit_id":3,"conversion_factor":1,"mrp":500,"selling_price":420,"is_default":null,"in_stock":65,"name":"Liter","abbreviation":"L"}],"images":[]},{"id":27,"is_active":0,"category_id":2,"name":"Ghee","units":[{"unit_id":3,"conversion_factor":1,"mrp":500,"selling_price":420,"is_default":null,"in_stock":65,"name":"Liter","abbreviation":"L"}],"images":[]},{"id":28,"is_active":0,"category_id":2,"name":"Ghee","units":[{"unit_id":3,"conversion_factor":1,"mrp":500,"selling_price":420,"is_default":null,"in_stock":65,"name":"Liter","abbreviation":"L"}],"images":[]},{"id":29,"is_active":0,"category_id":2,"name":"Ghee - variant","units":[{"unit_id":3,"conversion_factor":1,"mrp":500,"selling_price":420,"is_default":null,"in_stock":65,"name":"Liter","abbreviation":"L"},{"unit_id":4,"conversion_factor":500,"mrp":250,"selling_price":210,"is_default":null,"in_stock":63,"name":"Milliliter","abbreviation":"ml"}],"images":[]},{"id":30,"is_active":0,"category_id":2,"name":"Ghee - variant","units":[{"unit_id":3,"conversion_factor":1,"mrp":500,"selling_price":420,"is_default":null,"in_stock":65,"name":"Liter","abbreviation":"L"},{"unit_id":4,"conversion_factor":500,"mrp":250,"selling_price":210,"is_default":null,"in_stock":63,"name":"Milliliter","abbreviation":"ml"}],"images":[]},{"id":33,"is_active":1,"category_id":2,"name":"Tomato","units":[{"unit_id":1,"conversion_factor":1,"mrp":100,"selling_price":90,"is_default":1,"in_stock":7,"name":"Kilogram","abbreviation":"kg"}],"images":[]}]
    ''';
    
    List<dynamic> decodedData = jsonDecode(jsonData);
    List<Product> products = decodedData.map((item) => Product.fromJson(item)).toList();
    
    setState(() {
      _products = products;
      _filteredProducts = products;
      _isLoading = false;
    });
  }
  
  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        bool matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
        bool matchesActiveFilter = !_showActiveOnly || product.isActive;
        return matchesSearch && matchesActiveFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Maintenance'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadProducts();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterBar(),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(_filteredProducts[index]);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar() {
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
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        _filterProducts();
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
              _filterProducts();
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
                    _filterProducts();
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

  Widget _buildProductCard(Product product) {
    bool lowStock = product.units.any((unit) => unit.inStock < 10);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: lowStock ? Colors.red.shade300 : Colors.transparent,
          width: lowStock ? 1 : 0,
        ),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: product.isActive ? Colors.green : Colors.red,
              ),
              margin: const EdgeInsets.only(right: 8),
            ),
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'ID: ${product.id} • Category: ${product.categoryId}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lowStock)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Tooltip(
                  message: 'Low stock',
                  child: Icon(Icons.warning_amber_rounded, color: Colors.red[400]),
                ),
              ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditProductDialog(product);
                } else if (value == 'toggle') {
                  _toggleProductStatus(product);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle',
                  child: ListTile(
                    leading: Icon(
                      product.isActive ? Icons.visibility_off : Icons.visibility,
                    ),
                    title: Text(product.isActive ? 'Deactivate' : 'Activate'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Units',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...product.units.map((unit) => _buildUnitRow(product, unit)).toList(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add Unit'),
                      onPressed: () {
                        _showAddUnitDialog(product);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Product'),
                      onPressed: () {
                        _showEditProductDialog(product);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitRow(Product product, ProductUnit unit) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    bool isLowStock = unit.inStock < 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${unit.name} (${unit.abbreviation})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (unit.isDefault == true)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                  ],
                ),
                Text('Conversion: ${unit.conversionFactor}'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('MRP: ₹${formatter.format(unit.mrp)}'),
                Text('SP: ₹${formatter.format(unit.sellingPrice)}'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (isLowStock)
                          Icon(Icons.warning, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock: ${unit.inStock}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLowStock ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _updateStock(product, unit, false);
                          },
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            _updateStock(product, unit, true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
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
                  setState(() {
                    _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by name (Z-A)'),
                onTap: () {
                  setState(() {
                    _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by stock level (Low to High)'),
                onTap: () {
                  setState(() {
                    _filteredProducts.sort((a, b) {
                      int aStock = a.units.isEmpty ? 0 : a.units.first.inStock;
                      int bStock = b.units.isEmpty ? 0 : b.units.first.inStock;
                      return aStock.compareTo(bStock);
                    });
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by stock level (High to Low)'),
                onTap: () {
                  setState(() {
                    _filteredProducts.sort((a, b) {
                      int aStock = a.units.isEmpty ? 0 : a.units.first.inStock;
                      int bStock = b.units.isEmpty ? 0 : b.units.first.inStock;
                      return bStock.compareTo(aStock);
                    });
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by status (Active first)'),
                onTap: () {
                  setState(() {
                    _filteredProducts.sort((a, b) {
                      if (a.isActive == b.isActive) {
                        return a.name.compareTo(b.name);
                      }
                      return a.isActive ? -1 : 1;
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final categoryController = TextEditingController(text: '2'); // Default category
    bool isActive = true;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category ID',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // In a real app, this would send data to the backend
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Add Product'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditProductDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final categoryController = TextEditingController(text: product.categoryId.toString());
    bool isActive = product.isActive;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category ID',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Active'),
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // In a real app, this would update data in the backend
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Product updated successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddUnitDialog(Product product) {
    final nameController = TextEditingController();
    final abbreviationController = TextEditingController();
    final mrpController = TextEditingController();
    final spController = TextEditingController();
    final conversionController = TextEditingController(text: '1');
    final stockController = TextEditingController(text: '0');
    bool isDefault = false;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Unit'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Name',
                      ),
                    ),
                    TextField(
                      controller: abbreviationController,
                      decoration: const InputDecoration(
                        labelText: 'Abbreviation',
                      ),
                    ),
                    TextField(
                      controller: mrpController,
                      decoration: const InputDecoration(
                        labelText: 'MRP',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: spController,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: conversionController,
                      decoration: const InputDecoration(
                        labelText: 'Conversion Factor',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: stockController,
                      decoration: const InputDecoration(
                        labelText: 'Initial Stock',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Set as Default Unit'),
                      value: isDefault,
                      onChanged: (value) {
                        setState(() {
                          isDefault = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // In a real app, this would add unit to the backend
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Unit added successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Add Unit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateStock(Product product, ProductUnit unit, bool increase) {
    final stockController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${increase ? 'Add to' : 'Remove from'} Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Product: ${product.name}'),
              Text('Unit: ${unit.name} (${unit.abbreviation})'),
              Text('Current Stock: ${unit.inStock}'),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                decoration: InputDecoration(
                  labelText: '${increase ? 'Add' : 'Remove'} Quantity',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // In a real app, this would update stock in the backend
                int quantity = int.tryParse(stockController.text) ?? 0;
                if (quantity > 0) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${increase ? 'Added' : 'Removed'} $quantity ${unit.name} ${increase ? 'to' : 'from'} stock'
                      ),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text(increase ? 'Add' : 'Remove'),
            ),
          ],
        );
      },
    );
  }

  void _toggleProductStatus(Product product) {
    // In a real app, this would update status in the backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Product ${product.name} ${product.isActive ? 'deactivated' : 'activated'}'
        ),
      ),
    );
  }
}