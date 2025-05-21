import 'package:flutter/material.dart';
import 'dart:convert';



class Category {
  final int id;
  final String name;
  final List<Unit> units;

  Category({
    required this.id,
    required this.name,
    required this.units,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      units: (json['units'] as List)
          .map((unit) => Unit.fromJson(unit))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'units': units.map((unit) => unit.toJson()).toList(),
    };
  }
}

class Unit {
  final int id;
  final String name;
  final String abbreviation;

  Unit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
    };
  }
}

class CategoriesAdminScreen extends StatefulWidget {
  @override
  _CategoriesAdminScreenState createState() => _CategoriesAdminScreenState();
}

class _CategoriesAdminScreenState extends State<CategoriesAdminScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // In a real app, this would be an API call
    // For now, we'll use the sample data provided
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    const String jsonData = '''
    [
      {
        "id": 2,
        "name": "Ghee",
        "units": [
          {"id": 1, "name": "Kilogram", "abbreviation": "kg"},
          {"id": 2, "name": "Gram", "abbreviation": "g"}
        ]
      },
      {
        "id": 4,
        "name": "Incense stick",
        "units": [
          {"id": 5, "name": "Piece", "abbreviation": "pcs"}
        ]
      },
      {
        "id": 5,
        "name": "Cereals",
        "units": [
          {"id": 1, "name": "Kilogram", "abbreviation": "kg"},
          {"id": 2, "name": "Gram", "abbreviation": "g"}
        ]
      }
    ]
    ''';

    final List<dynamic> decodedData = jsonDecode(jsonData);
    final List<Category> loadedCategories = decodedData
        .map((item) => Category.fromJson(item))
        .toList();

    setState(() {
      _categories = loadedCategories;
      _isLoading = false;
    });
  }

  void _addCategory() async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => CategoryDialog(),
    );

    if (result != null) {
      setState(() {
        _categories.add(result);
      });
    }
  }

  void _editCategory(Category category, int index) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => CategoryDialog(category: category),
    );

    if (result != null) {
      setState(() {
        _categories[index] = result;
      });
    }
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete "${_categories[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _categories.removeAt(index);
              });
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCategory,
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                // Responsive design based on screen width
                if (constraints.maxWidth > 900) {
                  // Desktop layout - grid view
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(_categories[index], index);
                    },
                  );
                } else if (constraints.maxWidth > 600) {
                  // Tablet layout - 2 columns
                  return GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(_categories[index], index);
                    },
                  );
                } else {
                  // Mobile layout - list view
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryListItem(_categories[index], index);
                    },
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: Icon(Icons.add),
        tooltip: 'Add Category',
      ),
    );
  }

  Widget _buildCategoryCard(Category category, int index) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editCategory(category, index),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCategory(index),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'ID: ${category.id}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Units:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: category.units.length,
                itemBuilder: (context, unitIndex) {
                  final unit = category.units[unitIndex];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(unit.name),
                    subtitle: Text('${unit.abbreviation} (ID: ${unit.id})'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(Category category, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Text(
          category.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('ID: ${category.id}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editCategory(category, index),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteCategory(index),
              tooltip: 'Delete',
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Units:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: category.units.length,
                  itemBuilder: (context, unitIndex) {
                    final unit = category.units[unitIndex];
                    return ListTile(
                      dense: true,
                      title: Text(unit.name),
                      subtitle: Text('${unit.abbreviation} (ID: ${unit.id})'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final Category? category;

  const CategoryDialog({Key? key, this.category}) : super(key: key);

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late TextEditingController _nameController;
  List<Unit> _units = [];
  int _nextId = 100; // Temporary ID for new items

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController = TextEditingController(text: widget.category!.name);
      _units = List.from(widget.category!.units);
    } else {
      _nameController = TextEditingController();
      _units = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addUnit() {
    showDialog(
      context: context,
      builder: (context) => UnitDialog(),
    ).then((unit) {
      if (unit != null) {
        setState(() {
          _units.add(unit);
        });
      }
    });
  }

  void _editUnit(Unit unit, int index) {
    showDialog(
      context: context,
      builder: (context) => UnitDialog(unit: unit),
    ).then((updatedUnit) {
      if (updatedUnit != null) {
        setState(() {
          _units[index] = updatedUnit;
        });
      }
    });
  }

  void _removeUnit(int index) {
    setState(() {
      _units.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category == null ? 'Add Category' : 'Edit Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Units',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addUnit,
                    icon: Icon(Icons.add),
                    label: Text('Add Unit'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: _units.isEmpty
                    ? Center(
                        child: Text(
                          'No units added yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _units.length,
                        itemBuilder: (context, index) {
                          final unit = _units[index];
                          return ListTile(
                            title: Text(unit.name),
                            subtitle: Text('${unit.abbreviation} (ID: ${unit.id})'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editUnit(unit, index),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeUnit(index),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Category name is required')),
                        );
                        return;
                      }

                      final category = Category(
                        id: widget.category?.id ?? _nextId++,
                        name: _nameController.text.trim(),
                        units: _units,
                      );
                      Navigator.pop(context, category);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnitDialog extends StatefulWidget {
  final Unit? unit;

  const UnitDialog({Key? key, this.unit}) : super(key: key);

  @override
  _UnitDialogState createState() => _UnitDialogState();
}

class _UnitDialogState extends State<UnitDialog> {
  late TextEditingController _nameController;
  late TextEditingController _abbreviationController;
  int _nextId = 1000; // Temporary ID for new units

  @override
  void initState() {
    super.initState();
    if (widget.unit != null) {
      _nameController = TextEditingController(text: widget.unit!.name);
      _abbreviationController = TextEditingController(text: widget.unit!.abbreviation);
    } else {
      _nameController = TextEditingController();
      _abbreviationController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.unit == null ? 'Add Unit' : 'Edit Unit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Unit Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _abbreviationController,
              decoration: InputDecoration(
                labelText: 'Abbreviation',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty ||
                        _abbreviationController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('All fields are required')),
                      );
                      return;
                    }

                    final unit = Unit(
                      id: widget.unit?.id ?? _nextId++,
                      name: _nameController.text.trim(),
                      abbreviation: _abbreviationController.text.trim(),
                    );
                    Navigator.pop(context, unit);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}