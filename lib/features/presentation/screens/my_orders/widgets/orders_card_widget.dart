import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/my_orders/my_orders_response.dart';

class OrdersCardWidget extends StatefulWidget {
  final MyOrdersResponse order;
  final int index;
  const OrdersCardWidget({super.key, required this.order, required this.index});

  @override
  State<OrdersCardWidget> createState() => _OrdersCardWidgetState();
}

class _OrdersCardWidgetState extends State<OrdersCardWidget> {
  int _selectedOrderIndex = -1;
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == _selectedOrderIndex;
    final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final String formattedDate =
        widget.order.orderDate != null
            ? dateFormat.format(widget.order.orderDate!)
            : 'Date not available';

    final statusColor = _getStatusColor(widget.order.orderStatus ?? 'pending');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: Column(
        children: [
          // Order summary section
          InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedOrderIndex = -1;
                } else {
                  _selectedOrderIndex = widget.index;
                }
              });
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.orderReference ??
                                  'Order Reference Not Available',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          widget.order.orderStatus?.toUpperCase() ?? 'PENDING',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      if (widget.order.orderItems != null &&
                          widget.order.orderItems!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.order.orderItems![0].productImage ?? '',
                            height: 50,
                            width: 50,
                            placeholder:
                                (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                          ),
                        ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.order.orderItems?.length ?? 0} ${(widget.order.orderItems?.length ?? 0) > 1 ? 'items' : 'item'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.order.total != null)
                              Text(
                                '₹${widget.order.total!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded details section (visible when selected)
          if (isSelected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order items section
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (widget.order.orderItems != null &&
                      widget.order.orderItems!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.order.orderItems!.length,
                      itemBuilder: (context, itemIndex) {
                        final item = widget.order.orderItems![itemIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: item.productImage ?? '',
                                  height: 60,
                                  width: 60,
                                  placeholder:
                                      (context, url) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName ??
                                          'Product Name Not Available',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${item.quantity} × (${item.conversionFactor}${item.unitAbbreviation?.toLowerCase()})',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    if (item.productDescription != null)
                                      Text(
                                        item.productDescription!,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.itemSubTotal?.toStringAsFixed(2) ?? '0.00'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((item.itemDiscount ?? 0) > 0)
                                    Text(
                                      'Save ₹${item.itemDiscount?.toStringAsFixed(2) ?? '0.00'}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 12.0,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    const Text('No items available'),

                  const Divider(),

                  // Order summary
                  Row(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              'Subtotal',
                              '₹${widget.order.subTotal?.toStringAsFixed(2) ?? '0.00'}',
                            ),
                            if ((widget.order.discount ?? 0) > 0)
                              _buildSummaryRow(
                                'Discount',
                                '-₹${widget.order.discount?.toStringAsFixed(2) ?? '0.00'}',
                                isDiscount: true,
                              ),
                            if (widget.order.couponCode != null &&
                                widget.order.couponCode!.isNotEmpty)
                              _buildSummaryRow(
                                'Coupon',
                                widget.order.couponCode!,
                              ),
                            if ((widget.order.shippingCost ?? 0) > 0)
                              _buildSummaryRow(
                                'Shipping',
                                '₹${widget.order.shippingCost?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                            if ((widget.order.tax ?? 0) > 0)
                              _buildSummaryRow(
                                'Tax',
                                '₹${widget.order.tax?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                            const SizedBox(height: 4.0),
                            _buildSummaryRow(
                              'Total',
                              '₹${widget.order.total?.toStringAsFixed(2) ?? '0.00'}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Shipping Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(widget.order.name ?? 'Name not available'),
                            Text(
                              widget.order.mobileNo ?? 'Phone not available',
                            ),
                            if (widget.order.email != null)
                              Text(widget.order.email.toString()),
                            const SizedBox(height: 4.0),
                            Text(
                              widget.order.shippingAddress ??
                                  'Address not available',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13.0,
                              ),
                            ),
                            if (widget.order.orderNotes != null &&
                                widget.order.orderNotes!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Note: ${widget.order.orderNotes}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // Status timeline
                  if (widget.order.statusHistory != null &&
                      widget.order.statusHistory!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Timeline',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        _buildStatusTimeline(widget.order.statusHistory!),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(List<StatusHistory> statusHistory) {
    final DateFormat dateFormat = DateFormat('dd MMM, hh:mm a');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statusHistory.length,
      itemBuilder: (context, index) {
        final status = statusHistory[index];
        final isLastItem = index == statusHistory.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status.status ?? ''),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                if (!isLastItem)
                  Container(width: 2, height: 40, color: Colors.grey[300]),
              ],
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (status.status ?? '').toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    status.statusDescription ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  if (status.createdAt != null)
                    Text(
                      dateFormat.format(status.createdAt!),
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                    ),
                  if (!isLastItem) const SizedBox(height: 24.0),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey[700],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  isDiscount
                      ? Colors.green[700]
                      : (isTotal ? Colors.black : Colors.grey[700]),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
