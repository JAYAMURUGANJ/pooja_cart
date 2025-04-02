import 'package:flutter/material.dart';
import 'package:pooja_cart/features/presentation/common_widgets/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/pooja_item_utils.dart';
import '../../domain/entities/place_order/place_order_response.dart';

class WhatsappUtils {
  Future<void> shareOrderViaWhatsApp({
    required BuildContext context,
    required PlaceOrderResponse orderResponse,
    required String mobileNo,
  }) async {
    try {
      List<PlacedOrderItem> items = orderResponse.orderItems!;
      if (items.isEmpty) {
        return context.showSnackBar(message: 'Your order is empty');
      }

      final String whatsappNumber = mobileNo;

      final String orderText = ProductUtils.generateOrderSummary(orderResponse);
      final String encodedMessage = Uri.encodeComponent(orderText);
      final String formattedNumber = whatsappNumber.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

      final Uri whatsappUri = Uri.parse(
        'https://wa.me/$formattedNumber?text=$encodedMessage',
      );

      try {
        bool launched = await launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          if (context.mounted) {
            ProductUtils.showMessage(context, 'Could not launch WhatsApp.');
          }
        }
      } catch (e) {
        if (context.mounted) {
          ProductUtils.showMessage(context, 'Error opening WhatsApp: $e');
        }
      }
    } catch (e) {
      context.showSnackBar(message: e.toString());
    }
  }
}
