import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pooja_cart_item.dart';
import '../utils/pooja_item_utils.dart';

class OrderSummaryScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double mrptotal;
  final double discount;
  final double total;
  final String whatsappNumber = "9566632370";
  final Function(int, int)? onQuantityChanged;
  final Function()? onClearOrder;

  const OrderSummaryScreen({
    super.key,
    required this.cartItems,
    required this.mrptotal,
    required this.discount,
    required this.total,
    this.onQuantityChanged,
    this.onClearOrder,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late List<CartItem> _cartItems;
  late double _subtotal;
  late double _discount;
  late double _total;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _subtotal = widget.mrptotal;
    _discount = widget.discount;
    _total = widget.total;
  }

  @override
  void didUpdateWidget(OrderSummaryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cartItems != oldWidget.cartItems ||
        widget.mrptotal != oldWidget.mrptotal ||
        widget.discount != oldWidget.discount ||
        widget.total != oldWidget.total) {
      setState(() {
        _cartItems = List.from(widget.cartItems);
        _subtotal = widget.mrptotal;
        _discount = widget.discount;
        _total = widget.total;
      });
    }
  }

  void _updateCartItem(int itemId, int change) {
    if (widget.onQuantityChanged != null) {
      widget.onQuantityChanged!(itemId, change);
    }

    setState(() {
      final index = _cartItems.indexWhere((item) => item.item.id == itemId);
      if (index != -1) {
        final updatedQuantity = _cartItems[index].quantity + change;

        if (updatedQuantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          final item = _cartItems[index].item;
          _cartItems[index] = CartItem(item: item, quantity: updatedQuantity);
        }

        _recalculateTotals();
      }
    });
  }

  void _clearOrder() {
    PoojaItemUtils.showClearCartDialog(context, () {
      if (widget.onClearOrder != null) {
        widget.onClearOrder!();
      }

      setState(() {
        _cartItems.clear();
        _subtotal = 0.0;
        _discount = 0.0;
        _total = 0.0;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });
  }

  void _recalculateTotals() {
    _subtotal = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.item.mrp! * item.quantity),
    );

    _discount = _cartItems.fold(
      0.0,
      (sum, item) =>
          sum + ((item.item.mrp! - item.item.sellingPrice!) * item.quantity),
    );

    _total = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.item.sellingPrice! * item.quantity),
    );

    setState(() {
      _subtotal = double.parse(_subtotal.toStringAsFixed(2));
      _discount = double.parse(_discount.toStringAsFixed(2));
      _total = double.parse(_total.toStringAsFixed(2));
    });
  }

  Future<void> _shareOrderViaWhatsApp(BuildContext context) async {
    if (_cartItems.isEmpty) {
      _showMessage(context, 'Your order is empty');
      return;
    }

    final String orderSummary = PoojaItemUtils.generateOrderSummary(
      _cartItems,
      _subtotal,
      _discount,
      _total,
    );
    final String encodedMessage = Uri.encodeComponent(orderSummary);
    final String whatsappNumber = widget.whatsappNumber.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    ); // Ensure only digits

    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$whatsappNumber?text=$encodedMessage',
    );

    try {
      bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        if (context.mounted) {
          _showMessage(context, 'Could not launch WhatsApp.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Error opening WhatsApp: $e');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color:
                  _cartItems.isNotEmpty
                      ? Colors.red.shade400
                      : Colors.grey.shade400,
            ),
            onPressed: _cartItems.isEmpty ? null : _clearOrder,
            tooltip: 'Clear Order',
          ),
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color:
                  _cartItems.isNotEmpty
                      ? Colors.green.shade400
                      : Colors.grey.shade400,
            ),
            onPressed:
                _cartItems.isEmpty
                    ? null
                    : () => _shareOrderViaWhatsApp(context),
            tooltip: 'Share Order',
          ),
        ],
      ),
      body:
          _cartItems.isEmpty
              ? _buildEmptyOrderView()
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = _cartItems[index];
                        return _buildCartItemTile(cartItem);
                      },
                    ),
                  ),
                  _buildOrderSummaryFooter(),
                ],
              ),
    );
  }

  Widget _buildEmptyOrderView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your order is empty',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(CartItem cartItem) {
    final item = cartItem.item;
    final double itemTotal =
        (item.sellingPrice! * cartItem.quantity).toDouble();
    final double itemMrpTotal = (item.mrp! * cartItem.quantity).toDouble();
    final double discountTotal = (itemMrpTotal - itemTotal).toDouble();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          item.name!,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "₹${item.sellingPrice!.toStringAsFixed(2)} × ${cartItem.quantity}",
              style: const TextStyle(color: Colors.grey),
            ),
            if (discountTotal > 0) // Show discount only if applicable
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "You Save ₹${discountTotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "₹${itemTotal.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            IntrinsicWidth(
              child: PoojaItemUtils.buildQuantityControl(
                itemId: cartItem.item.id!,
                quantity: cartItem.quantity,
                onQuantityChanged: _updateCartItem,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal (MRP)"),
              Text("₹${_subtotal.toStringAsFixed(2)}"),
            ],
          ),
          if (_discount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Discount", style: TextStyle(color: Colors.green)),
                  Text(
                    "-₹${_discount.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${_total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.share_outlined),
              label: const Text("Send via WhatsApp"),
              onPressed: () => _shareOrderViaWhatsApp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
