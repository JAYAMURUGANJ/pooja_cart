// import 'package:flutter/material.dart';

// class UnitDialog extends StatefulWidget {
//   final Unit? unit;

//   const UnitDialog({super.key, this.unit});

//   @override
//   _UnitDialogState createState() => _UnitDialogState();
// }

// class _UnitDialogState extends State<UnitDialog> {
//   late TextEditingController _nameController;
//   late TextEditingController _abbreviationController;
//   int _nextId = 1000; // Temporary ID for new units

//   @override
//   void initState() {
//     super.initState();
//     if (widget.unit != null) {
//       _nameController = TextEditingController(text: widget.unit!.name);
//       _abbreviationController = TextEditingController(
//         text: widget.unit!.abbreviation,
//       );
//     } else {
//       _nameController = TextEditingController();
//       _abbreviationController = TextEditingController();
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _abbreviationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.unit == null ? 'Add Unit' : 'Edit Unit',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Unit Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _abbreviationController,
//               decoration: InputDecoration(
//                 labelText: 'Abbreviation',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Cancel'),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_nameController.text.trim().isEmpty ||
//                         _abbreviationController.text.trim().isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('All fields are required')),
//                       );
//                       return;
//                     }

//                     final unit = Unit(
//                       id: widget.unit?.id ?? _nextId++,
//                       name: _nameController.text.trim(),
//                       abbreviation: _abbreviationController.text.trim(),
//                     );
//                     Navigator.pop(context, unit);
//                   },
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
