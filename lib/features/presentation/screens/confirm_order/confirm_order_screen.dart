import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/presentation/screens/confirm_order/widgets/order_placed_widget.dart';

import 'bloc/place_order/place_order_bloc.dart';
import 'widgets/confirm_order_initial.dart';

final GlobalKey<FormState> _addressFormkey = GlobalKey<FormState>();

class ConfirmOrderScreen extends StatefulWidget {
  final List<OrderItems> orderItems;
  const ConfirmOrderScreen({super.key, required this.orderItems});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  List<OrderItems> get orderItems => widget.orderItems;
  @override
  void initState() {
    BlocProvider.of<PlaceOrderBloc>(context).add(ResetPlaceOrderEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceOrderBloc, PlaceOrderState>(
      builder: (context, state) {
        switch (state.status) {
          case PlaceOrderStatus.intial:
            return ConfirmOrderInitial(
              addressFormkey: _addressFormkey,
              orderItems: orderItems,
            );
          case PlaceOrderStatus.loading:
            return CircularProgressIndicator.adaptive();
          case PlaceOrderStatus.loaded:
            return OrderPlacedWidget(orderResponse: state.placeOrderResponse!);
          case PlaceOrderStatus.error:
            return Text(state.errorMsg!);
        }
      },
    );
  }
}
