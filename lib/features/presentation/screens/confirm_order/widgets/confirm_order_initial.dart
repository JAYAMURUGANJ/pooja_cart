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

final _nameController = TextEditingController();
final _mobileController = TextEditingController();
final _addressController = TextEditingController();
final _districtController = TextEditingController();
final _stateController = TextEditingController();
final _pincodeController = TextEditingController();

class ConfirmOrderInitial extends StatelessWidget {
  final GlobalKey<FormState> addressFormkey;
  final List<OrderItems> orderItems;

  const ConfirmOrderInitial({
    super.key,
    required this.addressFormkey,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          context.isMobile
              ? _buildMobileView(context)
              : _buildDesktopView(context),
      bottomNavigationBar: _buildPlaceOrderButton(context),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            child: ConfirmOrderItems(orderItems: orderItems),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(child: _buildOrderSummaryPanel(context)),
        ),
      ],
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(elevation: 2, child: ConfirmOrderItems(orderItems: orderItems)),
          const SizedBox(height: 16),
          _buildOrderSummaryPanel(context),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryPanel(BuildContext context) {
    return Card(
      margin: context.isMobile ? EdgeInsets.zero : const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPriceSummarySection(context),
            const Divider(height: 32, thickness: 1),
            AddressForm(
              formKey: addressFormkey,
              nameController: _nameController,
              mobileController: _mobileController,
              addressController: _addressController,
              districtController: _districtController,
              stateController: _stateController,
              pincodeController: _pincodeController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.receipt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Price Summary",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PriceDetailsWidget(items: orderItems),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => _handlePlaceOrder(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined),
              const SizedBox(width: 8),
              Text(
                "PLACE ORDER",
                style: TextStyle(
                  fontSize: context.responsiveFontSize(mobile: 16, desktop: 18),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) {
    if (orderItems.isEmpty) {
      return context.showSnackBar(message: "Your cart is empty");
    }

    if (addressFormkey.currentState!.validate()) {
      CommonRequestModel placeOrderRequest = CommonRequestModel(
        placeOrderRequest: PlaceOrderRequest(
          shippingDetails: ShippingDetails(
            name: _nameController.text,
            mobileNo: _mobileController.text,
            shippingAddress:
                "${_addressController.text}, ${_districtController.text}, ${_stateController.text},${_pincodeController.text}",
            shippingMethod: "Professional courier",
          ),
          orderItems: orderItems,
          paymentDetails: PaymentDetails(
            paymentMethod: "COD",
            transactionId: "",
          ),
          couponCode: "SAVE10",
          orderNotes: "Please deliver after 2 PM",
        ),
      );

      context.read<PlaceOrderBloc>().add(
        CreatePlaceOrderEvent(placeOrderRequest),
      );
    }
  }
}
