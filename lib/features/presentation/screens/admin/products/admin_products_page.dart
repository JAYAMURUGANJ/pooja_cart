import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/product/product_bloc.dart';

import '../add_new_item/widgets/add_new_form/add_new_item_form.dart';
import 'widgets/product_card/admin_product_card.dart';
import 'widgets/product_filter_section.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({super.key});

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(
      context,
    ).add(GetProductEvent(CommonRequestModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddItemScreen,
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.initial:
              return Center(child: CircularProgressIndicator());
            case ProductStatus.loading:
              return Center(child: CircularProgressIndicator());
            case ProductStatus.loaded:
              return _buildProductList(state.productResponse!);
            case ProductStatus.error:
              return Center(child: Text('Error loading products'));
          }
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

Widget _buildProductList(List<ProductResponse> products) {
  return Column(
    children: [
      ProductFilterSection(),
      Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return AdminProductCard(product: products[index]);
          },
        ),
      ),
    ],
  );
}
