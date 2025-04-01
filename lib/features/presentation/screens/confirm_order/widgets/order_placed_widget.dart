import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/place_order/place_order_response.dart';

class OrderPlacedWidget extends StatefulWidget {
  final PlaceOrderResponse orderResponse;
  const OrderPlacedWidget({super.key, required this.orderResponse});

  @override
  State<OrderPlacedWidget> createState() => _OrderPlacedWidgetState();
}

class _OrderPlacedWidgetState extends State<OrderPlacedWidget> {
  PlaceOrderResponse get orderResponse => widget.orderResponse;
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(orderResponse.orderReference!)]);
  }
}
