import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';

import '../../../../domain/entities/admin/admin_orders/admin_orders_response.dart';
import 'bloc/admin_orders/admin_orders_bloc.dart';
import 'widgets/order_filter_section.dart';
import 'widgets/order_item_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminOrdersBloc>(
      context,
    ).add(GetAllOrdersEvent(CommonRequestModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
        builder: (context, state) {
          switch (state.status) {
            case AdminOrdersStatus.initial:
              return Center(child: CircularProgressIndicator());
            case AdminOrdersStatus.loading:
              return Center(child: CircularProgressIndicator());
            case AdminOrdersStatus.loaded:
              return _buildOrderList(state.ordersResponse!);
            case AdminOrdersStatus.error:
              return Center(child: Text('Error loading orders'));
          }
        },
      ),
    );
  }

  _buildOrderList(List<AdminOrdersResponse> orders) {
    List<OrdersList> ordersList = orders.first.orders!;
    return Column(
      children: [
        OrderFilterSection(),
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ordersList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return OrderItemCard(item: ordersList[index]);
            },
          ),
        ),
      ],
    );
  }
}
