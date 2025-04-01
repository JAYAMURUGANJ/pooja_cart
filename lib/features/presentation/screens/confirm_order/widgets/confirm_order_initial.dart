import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/data/remote/model/request/place_order_request.dart';
import 'package:pooja_cart/features/presentation/common_widgets/extensions.dart';
import 'package:pooja_cart/features/presentation/screens/confirm_order/bloc/place_order/place_order_bloc.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../../../../domain/entities/order_items/order_items.dart';
import '../../order_summary/widgets/price_details_widget.dart';
import 'components/address_form.dart';
import 'components/confirm_order_items.dart';

class ConfirmOrderInitial extends StatelessWidget {
  final GlobalKey<FormState> addressFormkey;
  const ConfirmOrderInitial({
    super.key,
    required this.addressFormkey,
    required this.orderItems,
  });

  final List<OrderItems> orderItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConfirmOrderItems(orderItems: orderItems),
              20.ph,
              const Text(
                "Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              10.ph,
              AddressForm(formKey: addressFormkey),
              20.ph,
              Text(
                "Price Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              10.ph,
              PriceDetailsWidget(items: orderItems),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1.0)),
        color: Colors.deepOrange,
      ),
      height: 60,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.shopify_sharp, color: Colors.white),
        label: Text(
          "Confirm Order",
          style: TextStyle(
            fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          if (addressFormkey.currentState!.validate()) {
            CommonRequestModel placeOrderRequest = CommonRequestModel(
              placeOrderRequest: PlaceOrderRequest(
                shippingDetails: ShippingDetails(name: ""),
                orderItems: orderItems,
                paymentDetails: PaymentDetails(),
                couponCode: "SAVE10",
                orderNotes: "Please deliver after 2 PM",
              ),
            );

            BlocProvider.of<PlaceOrderBloc>(
              context,
            ).add(CreatePlaceOrderEvent(placeOrderRequest));
          }
          // print(orderItemsListToJson(items));
          // _shareOrderViaWhatsApp(context, items);
        },
      ),
    );
  }
}
