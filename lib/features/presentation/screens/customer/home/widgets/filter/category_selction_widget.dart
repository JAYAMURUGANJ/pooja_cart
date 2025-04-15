// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../bloc/category/category_bloc.dart';

// class CategorySelectionWidget extends StatelessWidget {
//   const CategorySelectionWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoryBloc, CategoryState>(
//       builder: (context, state) {
//         switch (state.status) {
//           case CategoryStatus.intial:
//             return const Center(child: CircularProgressIndicator());
//           case CategoryStatus.loading:
//             return const Center(child: CircularProgressIndicator());
//           case CategoryStatus.loaded:
//             return ExpansionTile(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Categories',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   if (_selectedCategoryIds.isNotEmpty)
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _selectedCategoryIds.clear();
//                           _selectedUnitIds.clear();
//                           _availableUnitIds = [];
//                         });
//                         _applyFilters();
//                       },
//                       icon: Icon(Icons.close),
//                     ),
//                 ],
//               ),
//               initiallyExpanded: false, // Expand if no functions selected
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 16,
//                     right: 16,
//                     bottom: 8,
//                   ),
//                   child: Wrap(
//                     spacing: 8.0,
//                     runSpacing: 8.0,
//                     children:
//                         state.categoryResponse!.map((category) {
//                           final bool isSelected = _selectedCategoryIds.contains(
//                             category.id,
//                           );
//                           return ChoiceChip(
//                             label: Text(
//                               category.name ?? '',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color:
//                                     isSelected ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                             selected: isSelected,
//                             showCheckmark: false,
//                             selectedColor:
//                                 Theme.of(context).colorScheme.primary,
//                             onSelected: (_) => _toggleCategory(category.id!),
//                             backgroundColor: Colors.grey.shade200,
//                           );
//                         }).toList(),
//                   ),
//                 ),

//                 // Only show units section if categories are selected
//                 if (_selectedCategoryIds.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16, right: 16),
//                     child: ExpansionTile(
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'Units',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (_selectedUnitIds.isNotEmpty)
//                             IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _selectedUnitIds.clear();
//                                 });
//                                 _applyFilters();
//                               },
//                               icon: Icon(Icons.close),
//                             ),
//                         ],
//                       ),
//                       initiallyExpanded: true,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             left: 8,
//                             right: 8,
//                             bottom: 16,
//                           ),
//                           child: Wrap(
//                             spacing: 8.0,
//                             runSpacing: 8.0,
//                             children:
//                                 pUnits.map((unit) {
//                                   final bool isSelected = _selectedUnitIds
//                                       .contains(unit.id);
//                                   final bool isEnabled = _availableUnitIds
//                                       .contains(unit.id);

//                                   return ChoiceChip(
//                                     label: Text(
//                                       unit.name ?? '',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color:
//                                             isSelected
//                                                 ? Colors.white
//                                                 : isEnabled
//                                                 ? Colors.black87
//                                                 : Colors.grey.shade400,
//                                       ),
//                                     ),
//                                     selected: isSelected,
//                                     showCheckmark: false,
//                                     selectedColor:
//                                         Theme.of(context).colorScheme.primary,
//                                     onSelected:
//                                         isEnabled
//                                             ? (_) => _toggleUnit(unit.id!)
//                                             : null,
//                                     backgroundColor:
//                                         isEnabled
//                                             ? Colors.grey.shade200
//                                             : Colors.grey.shade100,
//                                     disabledColor: Colors.grey.shade100,
//                                   );
//                                 }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 if (_selectedCategoryIds.isEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                       bottom: 16,
//                     ),
//                     child: Text(
//                       'Select a category to \nview available units',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ),
//               ],
//             );

//           default:
//             return Text("default");
//         }
//       },
//     );
//   }
// }
