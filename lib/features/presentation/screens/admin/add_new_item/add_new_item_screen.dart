import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import 'widgets/add_new_form/add_new_item_form.dart';
import 'widgets/available_items_widget.dart';

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add New Item"),
      ),
      body: context.isMobile ? _buildMobileUi() : _buildDesktopUi(),
    );
  }
}

_buildDesktopUi() {
  return Row(children: [AvailableItemsWidget(), AddNewItemForm()]);
}

_buildMobileUi() {
  return Column(children: [AddNewItemForm()]);
}
