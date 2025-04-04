import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/my_orders/widgets/orders_card_widget.dart';

import '../bloc/my_orders/my_orders_bloc.dart';
import 'error_card.dart';

class OrdersDisplayWidget extends StatelessWidget {
  const OrdersDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOrdersBloc, MyOrdersState>(
      builder: (context, state) {
        switch (state.status) {
          case MyOrdersStatus.intial:
            return const Center(
              child: Text(
                'Search for an order or view your order history',
                style: TextStyle(fontSize: 16.0),
              ),
            );

          case MyOrdersStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case MyOrdersStatus.loaded:
            if (state.myOrdersResponse != null &&
                state.myOrdersResponse!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Orders (${state.myOrdersResponse!.length})',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.myOrdersResponse!.length,
                    itemBuilder: (context, index) {
                      return OrdersCardWidget(
                        order: state.myOrdersResponse![index],
                        index: index,
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            }
          case MyOrdersStatus.error:
            return Center(child: OrderErrorCard(errorMsg: state.errorMsg!));
        }
      },
    );
  }
}
