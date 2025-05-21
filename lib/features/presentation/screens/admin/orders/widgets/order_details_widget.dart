import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/entities/admin/admin_orders/admin_orders_response.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrdersList order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String _selectedStatus = '';
  final TextEditingController _noteController = TextEditingController();
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus =
        widget.order.orderStatus!.isEmpty
            ? 'Pending'
            : widget.order.orderStatus!;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the date
    final orderDate = DateTime.parse(widget.order.orderDate.toString());
    final formattedDate = DateFormat(
      'MMMM dd, yyyy • hh:mm a',
    ).format(orderDate);

    // Calculate order summary
    final totalDiscount = widget.order.orderItems!.fold<double>(
      0,
      (sum, item) => sum + item.itemDiscount!,
    );
    final totalItems = widget.order.orderItems!.fold<int>(
      0,
      (sum, item) => sum + item.quantity!,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.order.orderId}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Print order
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printing order details...')),
              );
            },
            tooltip: 'Print Order',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share order
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing order details...')),
              );
            },
            tooltip: 'Share Order',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _showDeleteConfirmation(context);
                  break;
                case 'export':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting order details...')),
                  );
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'export',
                    child: ListTile(
                      leading: Icon(Icons.download_outlined),
                      title: Text('Export Order'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text(
                        'Delete Order',
                        style: TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      body:
          _isUpdatingStatus
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderStatusBar(_selectedStatus),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Order Information',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _buildStatusChip(_selectedStatus),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                    'Order ID',
                                    '#${widget.order.orderId}',
                                  ),
                                  _buildDetailRow('Order Date', formattedDate),
                                  _buildDetailRow(
                                    'Payment Method',
                                    widget.order.paymentMethod!.isEmpty
                                        ? 'Not specified'
                                        : widget.order.paymentMethod!,
                                  ),
                                  _buildDetailRow(
                                    'Shipping Method',
                                    widget.order.shippingMethod!.isEmpty
                                        ? 'Standard'
                                        : widget.order.shippingMethod!,
                                  ),
                                  _buildDetailRow(
                                    'Items Count',
                                    '$totalItems items',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Customer Information',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailRow(
                                          'Name',
                                          widget.order.name!,
                                        ),
                                        _buildDetailRow(
                                          'Phone',
                                          widget.order.mobileNo!,
                                        ),
                                        // Additional customer details would go here
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Order Items',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  widget.order.orderItems!.isEmpty
                                      ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text('No items available'),
                                        ),
                                      )
                                      : _buildOrderItemsList(),
                                  const Divider(height: 32),
                                  Column(
                                    children: [
                                      _buildSummaryRow(
                                        'Subtotal',
                                        '₹${widget.order.subTotal!.toStringAsFixed(2)}',
                                      ),
                                      _buildSummaryRow(
                                        'Discount',
                                        '₹${totalDiscount.toStringAsFixed(2)}',
                                        textColor: Colors.green,
                                      ),
                                      _buildSummaryRow('Shipping', '₹0.00'),
                                      const Divider(),
                                      _buildSummaryRow(
                                        'Total',
                                        '₹${widget.order.total!.toStringAsFixed(2)}',
                                        isBold: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildUpdateStatusSection(context),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Orders'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('Generate Invoice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating invoice...')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.order.orderItems!.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = widget.order.orderItems![index];
        return _buildOrderItemCard(item);
      },
    );
  }

  Widget _buildOrderItemCard(OrderItem item) {
    // Calculate the discount percentage
    final discountPercent =
        item.mrp! > 0
            ? ((item.mrp! - item.sellingPrice!) / item.mrp! * 100).round()
            : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                item.productImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImage!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                      ),
                    )
                    : const Icon(
                      Icons.shopping_basket_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  item.productDescription!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${item.quantity} ${item.unitAbbreviation}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Text(' × '),
                    Text(
                      '₹${item.sellingPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (discountPercent > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Text(
                          '$discountPercent% OFF',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Price Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.itemSubTotal!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (item.mrp != item.sellingPrice)
                Text(
                  '₹${item.mrp!.toStringAsFixed(2)}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              if (item.itemDiscount! > 0)
                Text(
                  'Saved: ₹${item.itemDiscount!.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor ?? Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    // Default status if empty
    status = status.isEmpty ? 'Pending' : status;

    // Determine status color
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusColor = Colors.blue;
        break;
      case 'shipped':
        statusColor = Colors.indigo;
        break;
      case 'delivered':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      case 'returned':
        statusColor = Colors.purple;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildOrderStatusBar(String status) {
    // Default status if empty
    status = status.isEmpty ? 'Pending' : status;

    final statusMap = {
      'Pending': 0,
      'Processing': 1,
      'Shipped': 2,
      'Delivered': 3,
      'Cancelled': -1,
      'Returned': -1,
    };

    final currentStep = statusMap[status] ?? 0;

    // If cancelled or returned, show different UI
    if (status == 'Cancelled' || status == 'Returned') {
      return Container(
        color: status == 'Cancelled' ? Colors.red[50] : Colors.purple[50],
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              status == 'Cancelled' ? Icons.cancel : Icons.assignment_return,
              color: status == 'Cancelled' ? Colors.red : Colors.purple,
            ),
            const SizedBox(width: 8),
            Text(
              'Order $status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'Cancelled' ? Colors.red : Colors.purple,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.grey[100],
      child: Stepper(
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) => Container(),
        currentStep: currentStep,
        steps: [
          _buildStep('Pending', 'Order received', 0, currentStep),
          _buildStep('Processing', 'Order is being processed', 1, currentStep),
          _buildStep('Shipped', 'Order has been shipped', 2, currentStep),
          _buildStep('Delivered', 'Order has been delivered', 3, currentStep),
        ],
      ),
    );
  }

  Step _buildStep(String title, String content, int index, int currentStep) {
    return Step(
      title: Text(
        title,
        style: TextStyle(
          fontWeight:
              currentStep >= index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      content: Text(content),
      isActive: currentStep >= index,
      state: currentStep > index ? StepState.complete : StepState.indexed,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
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

  Widget _buildUpdateStatusSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Order Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                DropdownMenuItem(
                  value: 'Processing',
                  child: Text('Processing'),
                ),
                DropdownMenuItem(value: 'Shipped', child: Text('Shipped')),
                DropdownMenuItem(value: 'Delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                DropdownMenuItem(value: 'Returned', child: Text('Returned')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add a note (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter any notes about this status update',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  setState(() {
                    _isUpdatingStatus = true;
                  });

                  // Simulate API call
                  await Future.delayed(const Duration(seconds: 1));

                  setState(() {
                    _isUpdatingStatus = false;
                  });

                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order status updated successfully'),
                      ),
                    );
                  }
                },
                child: const Text('Update Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: Text(
            'Are you sure you want to delete Order #${widget.order.orderId}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Order #${widget.order.orderId} has been deleted',
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
