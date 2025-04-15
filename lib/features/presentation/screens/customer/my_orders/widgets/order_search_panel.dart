import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/remote/model/request/common_request_model.dart';
import '../bloc/my_orders/my_orders_bloc.dart';

final TextEditingController _searchController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class OrderSearchPanel extends StatelessWidget {
  const OrderSearchPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find Your Order',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Order ID or Mobile Number',
                  hintText: 'Enter Order ID (ORDxxx) or Mobile Number',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Order ID or Mobile Number';
                  }
                  if (!isValidOrderId(value) && !isValidMobileNumber(value)) {
                    return 'Enter a valid Order ID (ORDxxx) or 10-digit Mobile Number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => _searchOrder(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text('Search Orders'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _searchOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final searchText = _searchController.text.trim();
      final bloc = BlocProvider.of<MyOrdersBloc>(context);

      if (isValidOrderId(searchText)) {
        bloc.add(GetMyOrdersByIdEvent(CommonRequestModel(orderId: searchText)));
      } else if (isValidMobileNumber(searchText)) {
        bloc.add(
          GetMyOrdersByMobileEvent(CommonRequestModel(mobileNo: searchText)),
        );
      }
    }
  }

  bool isValidOrderId(String value) {
    return value.toUpperCase().startsWith('ORD');
  }

  bool isValidMobileNumber(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }
}
