// import 'package:flutter/material.dart';
// import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
// import 'package:pooja_cart/models/pooja_items_units.dart';
// import 'package:pooja_cart/utils/pooja_item_utils.dart';
// import 'package:pooja_cart/utils/responsive_utils.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../common_widgets/head_container.dart';
// import '../home/widgets/empty_cart.dart';

// Widget _orderSummary(
//   BuildContext context,
//   List<OrderItems> orderItems,
//   Map<String, double> orderSummary,
// ) {
//   final contentSidebarRatio = context.contentSidebarRatio;

//   return Expanded(
//     flex: contentSidebarRatio[1],
//     child: Container(
//       color: Colors.grey.shade50,
//       child: Column(
//         children: [
//           _orderSummaryHead(context),
//           _orderSummaryBody(context, orderItems),
//           if (orderItems.isNotEmpty)
//             _buildOrderSummaryFooter(
//               context,
//               orderSummary['mrpTotal']!,
//               orderSummary['discount']!,
//               orderSummary['total']!,
//             ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _orderSummaryHead(BuildContext context) {
//   return HeadContainer(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "Order Summary",
//           style: TextStyle(
//             fontSize: context.responsiveFontSize(mobile: 18, desktop: 22),
//             fontWeight: FontWeight.w600,
//             color: Theme.of(context).colorScheme.onSecondary,
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.delete_outline,
//             size: context.responsiveIconSize,
//             // color:
//             //     (itemQuantities.isNotEmpty)
//             //         ? Colors.red.shade400
//             //         : Colors.grey.shade400,
//           ),
//           onPressed:
//               // (itemQuantities.isNotEmpty)
//               //     ? () {
//               //       ProductUtils.showClearCartDialog(context, clearAllItems);
//               //     }
//               //     :
//               null,
//         ),
//       ],
//     ),
//   );
// }

// Expanded _orderSummaryBody(BuildContext context, List<OrderItems> cartItems) {
//   return Expanded(
//     child:
//         cartItems.isEmpty
//             ? EmptyCart(context: context)
//             : ListView.builder(
//               padding: context.responsivePadding,
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final cartItem = cartItems[index];
//                 return _buildCartItemTile(context, cartItem);
//               },
//             ),
//   );
// }

// Widget _buildOrderSummaryFooter(
//   BuildContext context,
//   double subtotal,
//   double discount,
//   double total,
// ) {
//   return Container(
//     padding: context.responsivePadding.copyWith(
//       top: context.standardSpacing * 1.5,
//       bottom: context.standardSpacing * 1.5,
//     ),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(12),
//         topRight: Radius.circular(12),
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withValues(alpha: 0.1),
//           spreadRadius: 1,
//           blurRadius: 6,
//           offset: const Offset(0, -2),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         // MRP total
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Subtotal (MRP)",
//               style: TextStyle(
//                 fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             Text(
//               "₹${subtotal.toStringAsFixed(2)}",
//               style: TextStyle(
//                 fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: context.standardSpacing / 2),
//         // If discount available
//         if (discount > 0)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Discount",
//                 style: TextStyle(
//                   color: Colors.green.shade600,
//                   fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "-₹${discount.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   color: Colors.green.shade600,
//                   fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         Divider(color: Colors.grey.shade300, thickness: 1),
//         SizedBox(height: context.standardSpacing / 2),
//         // Total amount
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Total",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//             Text(
//               "₹${total.toStringAsFixed(2)}",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: context.responsiveFontSize(mobile: 18, desktop: 20),
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: context.standardSpacing),
//         // Share WhatsApp button
//         SizedBox(
//           width: double.infinity,
//           height: context.controlHeight,
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.shopify_sharp, color: Colors.white),
//             label: Text(
//               "Confirm Order",
//               style: TextStyle(
//                 fontSize: context.responsiveFontSize(mobile: 14, desktop: 16),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             onPressed: () => _shareOrderViaWhatsApp(context),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildCartItemTile(BuildContext context, OrderItems orderItems) {
//   final item = /* cartItem.quantity */ 1;
//   final double itemTotal = /* (item.sellingPrice! * cartItem.).toDouble() */ 1;
//   final double itemMrpTotal = /*  (item.mrp! * cartItem.quantity).toDouble() */
//       1;
//   final double discountTotal = (itemMrpTotal - itemTotal).toDouble();

//   return Container(
//     margin: EdgeInsets.only(bottom: context.standardSpacing),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: Colors.grey.shade200),
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withValues(alpha: 0.1),
//           blurRadius: 6,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Padding(
//       padding: context.responsivePadding,
//       child: Column(
//         children: [
//           // Item and unit
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 flex: 2,
//                 child: Text(
//                   orderItems.name!,
//                   textAlign: TextAlign.left,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: context.responsiveFontSize(
//                       mobile: 13,
//                       desktop: 15,
//                     ),
//                     color: Theme.of(context).colorScheme.primary,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 1,
//                 child: Text(
//                   "${1 /* item.unitCount */} ${ProductUtils().getUnitName(orderItems.unitId!, [PoojaUnits()])}",
//                   style: TextStyle(
//                     color: Colors.grey.shade700,
//                     fontSize: context.responsiveFontSize(
//                       mobile: 12,
//                       desktop: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: context.standardSpacing / 2),
//           // Price
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "(₹${ /* item.sellingPrice!.toStringAsFixed(2) */ 5} × ${ /* orderItems.quantity */ 5})",
//                 style: TextStyle(
//                   color: Colors.grey.shade700,
//                   fontSize: context.responsiveFontSize(mobile: 12, desktop: 14),
//                 ),
//               ),
//               Text(
//                 "₹${itemTotal.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: context.responsiveFontSize(mobile: 15, desktop: 17),
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: context.standardSpacing / 2),
//           // Quantity controls
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (discountTotal > 0)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 6,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.inversePrimary,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     "You Save ₹${discountTotal.toStringAsFixed(2)}",
//                     style: TextStyle(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontSize: context.responsiveFontSize(
//                         mobile: 10,
//                         desktop: 12,
//                       ),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               /*  QuantityController(
//                 itemId: orderItems.item.id!,
//                 quantity: orderItems.quantity,
//                 onQuantityChanged: updateQuantity,
//                 width: 100,
//               ), */
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Future<void> _shareOrderViaWhatsApp(BuildContext context) async {
//   final cartItems = [] /* getCartItems() */;
//   if (cartItems.isEmpty) {
//     ProductUtils.showMessage(context, 'Your order is empty');
//     return;
//   }

//   final orderSummary = [] /* getOrderSummary() */;
//   final String whatsappNumber = "9566632370";

//   final String orderText = "";
//   /*  ProductUtils.generateOrderSummary(
//     cartItems,
//     orderSummary['mrpTotal']!,
//     orderSummary['discount']!,
//     orderSummary['total']!,
//   ); */
//   final String encodedMessage = Uri.encodeComponent(orderText);
//   final String formattedNumber = whatsappNumber.replaceAll(
//     RegExp(r'[^0-9]'),
//     '',
//   );

//   final Uri whatsappUri = Uri.parse(
//     'https://wa.me/$formattedNumber?text=$encodedMessage',
//   );

//   try {
//     bool launched = await launchUrl(
//       whatsappUri,
//       mode: LaunchMode.externalApplication,
//     );
//     if (!launched) {
//       if (context.mounted) {
//         ProductUtils.showMessage(context, 'Could not launch WhatsApp.');
//       }
//     }
//   } catch (e) {
//     if (context.mounted) {
//       ProductUtils.showMessage(context, 'Error opening WhatsApp: $e');
//     }
//   }
// }
