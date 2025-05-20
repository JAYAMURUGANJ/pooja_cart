import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/product/product_bloc.dart';

import '../add_new_item/widgets/add_new_form/add_new_item_form.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddItemScreen,
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            children: [
              Text("Products"),
              ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(trailing: Text("Edit"));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToAddItemScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => AddNewItemForm(),
    );
    // context.go('/admin/add_product');
  }
}
