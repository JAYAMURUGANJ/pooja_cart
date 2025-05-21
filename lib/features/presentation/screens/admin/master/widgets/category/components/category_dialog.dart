// import 'package:flutter/material.dart';
// import 'package:pooja_cart/features/domain/entities/category/category_response.dart';
// import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';

// class CategoryDialog extends StatefulWidget {
//   final CategoryResponse? category;

//   const CategoryDialog({super.key, this.category});

//   @override
//   _CategoryDialogState createState() => _CategoryDialogState();
// }

// class _CategoryDialogState extends State<CategoryDialog> {
//   late TextEditingController _nameController;
//   List<UnitResponse> _units = [];
//   int _nextId = 100; // Temporary ID for new items

//   @override
//   void initState() {
//     super.initState();
//     if (widget.category != null) {
//       _nameController = TextEditingController(text: widget.category!.name);
//       _units = List.from(widget.category!.units!);
//     } else {
//       _nameController = TextEditingController();
//       _units = [];
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   void _addUnit() {
//     showDialog(context: context, builder: (context) => UnitDialog()).then((
//       unit,
//     ) {
//       if (unit != null) {
//         setState(() {
//           _units.add(unit);
//         });
//       }
//     });
//   }

//   void _editUnit(UnitResponse unit, int index) {
//     showDialog(
//       context: context,
//       builder: (context) => UnitDialog(unit: unit),
//     ).then((updatedUnit) {
//       if (updatedUnit != null) {
//         setState(() {
//           _units[index] = updatedUnit;
//         });
//       }
//     });
//   }

//   void _removeUnit(int index) {
//     setState(() {
//       _units.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 500,
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.category == null ? 'Add Category' : 'Edit Category',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Category Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Units',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: _addUnit,
//                     icon: Icon(Icons.add),
//                     label: Text('Add Unit'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Expanded(
//                 child:
//                     _units.isEmpty
//                         ? Center(
//                           child: Text(
//                             'No units added yet',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         )
//                         : ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _units.length,
//                           itemBuilder: (context, index) {
//                             final unit = _units[index];
//                             return ListTile(
//                               title: Text(unit.name),
//                               subtitle: Text(
//                                 '${unit.abbreviation} (ID: ${unit.id})',
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.edit),
//                                     onPressed: () => _editUnit(unit, index),
//                                     tooltip: 'Edit',
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.delete),
//                                     onPressed: () => _removeUnit(index),
//                                     tooltip: 'Delete',
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('Cancel'),
//                   ),
//                   SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_nameController.text.trim().isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Category name is required')),
//                         );
//                         return;
//                       }

//                       final category = Category(
//                         id: widget.category?.id ?? _nextId++,
//                         name: _nameController.text.trim(),
//                         units: _units,
//                       );
//                       Navigator.pop(context, category);
//                     },
//                     child: Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
