import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pooja_cart/features/domain/entities/place_order/place_order_response.dart';

import '../../../../../common/utils/whatsapp_utils.dart';

class OrderSuccessWidget extends StatelessWidget {
  final PlaceOrderResponse orderResponse;

  const OrderSuccessWidget({super.key, required this.orderResponse});

  @override
  Widget build(BuildContext context) {
    // Get the order data from response
    final PlaceOrderResponse order = orderResponse;
    final List<PlacedOrderItem> orderItems = order.orderItems!;
    final ShippingDetails shippingDetails = order.shippingDetails!;

    // Format date
    final orderDate = DateTime.parse(order.orderDate.toString());
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(orderDate);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48.0,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Order Placed Successfully!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Order ID: ${order.orderReference}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Date: $formattedDate',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Shipping Details
              _buildSectionTitle('Shipping Details'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Name', shippingDetails.name!),
                      _buildInfoRow('Mobile', shippingDetails.mobileNo!),
                      if (shippingDetails.email != null)
                        _buildInfoRow('Email', shippingDetails.email!),
                      _buildInfoRow(
                        'Address',
                        shippingDetails.shippingAddress!,
                      ),
                      if (order.orderNotes!.isNotEmpty)
                        _buildInfoRow('Notes', order.orderNotes!),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Order Items
              _buildSectionTitle('Order Items'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      for (final item in orderItems)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item.productImage!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${item.quantity} × (${item.conversionFactor}${item.unitAbbreviation})',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                              // Price Details
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.itemSubTotal!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.itemDiscount! > 0)
                                    Text(
                                      'Save ₹${item.itemDiscount!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 12.0,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      // Order Summary
                      _buildPriceRow('Subtotal', order.subTotal!),
                      if (order.discount! > 0)
                        _buildPriceRow(
                          'Discount',
                          -order.discount!,
                          isDiscount: true,
                        ),
                      if (order.couponCode!.isNotEmpty)
                        _buildPriceRow(
                          'Coupon (${order.couponCode})',
                          0,
                          isDiscount: false,
                        ),
                      _buildPriceRow('Shipping', order.shippingCost!),
                      _buildPriceRow('Tax', order.tax!),
                      const Divider(),
                      _buildPriceRow('Total', order.total!, isTotal: true),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Payment Details
              _buildSectionTitle('Payment Details'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Status', order.orderStatus!.toUpperCase()),
                      _buildInfoRow(
                        'Payment Method',
                        order.paymentDetails!.paymentMethod!.isNotEmpty
                            ? order.paymentDetails!.paymentMethod!
                            : 'Pending',
                      ),
                      if (order.paymentDetails!.transactionId != null)
                        _buildInfoRow(
                          'Transaction ID',
                          order.paymentDetails!.transactionId!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomSection(
        context,
        shippingDetails.mobileNo!,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16.0 : 14.0,
            ),
          ),
          Text(
            isDiscount
                ? '-₹${amount.abs().toStringAsFixed(2)}'
                : '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isDiscount ? Colors.green[700] : null,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16.0 : 14.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomSection(BuildContext context, String mobileNo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        spacing: 16,
        children: [
          // Continue Shopping Button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.replace("/");
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Continue Shopping'),
            ),
          ),
          // Share Order Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                WhatsappUtils().shareOrderViaWhatsApp(
                  context: context,
                  orderResponse: orderResponse,
                  mobileNo: mobileNo,
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Order Details'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
