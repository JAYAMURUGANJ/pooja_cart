import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/presentation/common_widgets/extensions.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import '../order_summary/widgets/price_details_widget.dart';
import 'widgets/address_form.dart';
import 'widgets/confirm_order_items.dart';

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
              AddressForm(formKey: _addressFormkey),
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
          if (_addressFormkey.currentState!.validate()) {
            var confirmOrder = {
              "shipping_details": {
                "name": "",
                "mobile_no": "",
                "shipping_address": "",
              },
              "order_items": [
                {
                  "product_id": 0,
                  "unit_id": 0,
                  "quantity": 2,
                  "selling_price": 0,
                  "mrp": 0,
                },
              ],
              "sub_total": "",
              "total": "",
              "discount": "",
            };
            print(confirmOrder);
          }
          // print(orderItemsListToJson(items));
          // _shareOrderViaWhatsApp(context, items);
        },
      ),
    );
  }
}
