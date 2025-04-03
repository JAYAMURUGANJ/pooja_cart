import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pooja_cart/features/data/remote/model/request/common_request_model.dart';
import 'package:pooja_cart/features/domain/entities/my_orders/my_orders_response.dart';
import 'package:pooja_cart/features/presentation/screens/my_orders/bloc/my_orders/my_orders_bloc.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isExpanded = false;
  int _selectedOrderIndex = -1;

  @override
  void initState() {
    super.initState();
    // Load all orders on init (optional)
    _fetchAllOrders();
  }

  void _fetchAllOrders() {
    CommonRequestModel request = CommonRequestModel(orderId: "ORD35");

    final bloc = BlocProvider.of<MyOrdersBloc>(context);
    bloc.add(GetMyOrdersByIdEvent(request));
  }

  void _searchOrder() {
    if (_formKey.currentState!.validate()) {
      final bloc = BlocProvider.of<MyOrdersBloc>(context);
      final orderReference = _searchController.text.trim();

      if (orderReference.isNotEmpty) {
        CommonRequestModel request = CommonRequestModel(
          orderId: orderReference,
        );
        bloc.add(GetMyOrdersByIdEvent(request));
      } else {
        _fetchAllOrders();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout based on width
          final isWideScreen = constraints.maxWidth > 900;

          if (isWideScreen) {
            // Desktop/Tablet layout (Side by side)
            return _buildWideScreenLayout();
          } else {
            // Mobile layout (Stacked)
            return _buildNarrowScreenLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search panel (30% width)
        Container(
          width: 320,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: _buildSearchPanel(),
        ),

        // Orders display (70% width)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildOrdersDisplay(),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search panel
            _buildSearchPanel(),

            const SizedBox(height: 24.0),

            // Orders display
            _buildOrdersDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Find Your Order',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16.0),

        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Order Reference',
                  hintText: 'Enter order number (e.g. ORD35)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.toUpperCase().startsWith('ORD')) {
                      return 'Order reference should start with ORD';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _searchOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: const Text('Search Orders'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              TextButton(
                onPressed: () {
                  _searchController.clear();
                  _fetchAllOrders();
                },
                child: const Text('View All Orders'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24.0),

        BlocBuilder<MyOrdersBloc, MyOrdersState>(
          builder: (context, state) {
            if (state.status == MyOrdersStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == MyOrdersStatus.error) {
              return _buildErrorCard(state.errorMsg!);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildOrdersDisplay() {
    return BlocBuilder<MyOrdersBloc, MyOrdersState>(
      builder: (context, state) {
        switch (state.status) {
          case MyOrdersStatus.intial:
            return const Center(
              child: Text(
                'Search for an order or view your order history',
                style: TextStyle(fontSize: 16.0),
              ),
            );

          case MyOrdersStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case MyOrdersStatus.loaded:
            if (state.myOrdersResponse != null &&
                state.myOrdersResponse!.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Orders (${state.myOrdersResponse!.length})',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.myOrdersResponse!.length,
                    itemBuilder: (context, index) {
                      return _buildOrderCard(
                        state.myOrdersResponse![index],
                        index,
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
            }

          case MyOrdersStatus.error:
            return Center(child: _buildErrorCard(state.errorMsg!));
        }
      },
    );
  }

  Widget _buildOrderCard(MyOrdersResponse order, int index) {
    final isSelected = index == _selectedOrderIndex;
    final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final String formattedDate =
        order.orderDate != null
            ? dateFormat.format(order.orderDate!)
            : 'Date not available';

    final statusColor = _getStatusColor(order.orderStatus ?? 'pending');

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
                  _selectedOrderIndex = index;
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
                              order.orderReference ??
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
                          order.orderStatus?.toUpperCase() ?? 'PENDING',
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
                      if (order.orderItems != null &&
                          order.orderItems!.isNotEmpty)
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(8.0),
                        //   child: Image.network(
                        //     order.orderItems![0].productImage ?? '',
                        //     width: 50,
                        //     height: 50,
                        //     fit: BoxFit.cover,
                        //     errorBuilder: (context, error, stackTrace) {
                        //       return Container(
                        //         width: 50,
                        //         height: 50,
                        //         color: Colors.grey[200],
                        //         child: const Icon(Icons.image_not_supported),
                        //       );
                        //     },
                        //   ),
                        // ),
                        const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order.orderItems?.length ?? 0} ${(order.orderItems?.length ?? 0) > 1 ? 'items' : 'item'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (order.total != null)
                              Text(
                                '₹${order.total!.toStringAsFixed(2)}',
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
                  if (order.orderItems != null && order.orderItems!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.orderItems!.length,
                      itemBuilder: (context, itemIndex) {
                        final item = order.orderItems![itemIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(8.0),
                              //   child: Image.network(
                              //     item.productImage ?? '',
                              //     width: 60,
                              //     height: 60,
                              //     fit: BoxFit.cover,
                              //     errorBuilder: (context, error, stackTrace) {
                              //       return Container(
                              //         width: 60,
                              //         height: 60,
                              //         color: Colors.grey[200],
                              //         child: const Icon(
                              //           Icons.image_not_supported,
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
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
                                      '${item.quantity} × ${item.unitName} (${item.unitAbbreviation})',
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              'Subtotal',
                              '₹${order.subTotal?.toStringAsFixed(2) ?? '0.00'}',
                            ),
                            if ((order.discount ?? 0) > 0)
                              _buildSummaryRow(
                                'Discount',
                                '-₹${order.discount?.toStringAsFixed(2) ?? '0.00'}',
                                isDiscount: true,
                              ),
                            if (order.couponCode != null &&
                                order.couponCode!.isNotEmpty)
                              _buildSummaryRow('Coupon', order.couponCode!),
                            if ((order.shippingCost ?? 0) > 0)
                              _buildSummaryRow(
                                'Shipping',
                                '₹${order.shippingCost?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                            if ((order.tax ?? 0) > 0)
                              _buildSummaryRow(
                                'Tax',
                                '₹${order.tax?.toStringAsFixed(2) ?? '0.00'}',
                              ),
                            const SizedBox(height: 4.0),
                            _buildSummaryRow(
                              'Total',
                              '₹${order.total?.toStringAsFixed(2) ?? '0.00'}',
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
                            Text(order.name ?? 'Name not available'),
                            Text(order.mobileNo ?? 'Phone not available'),
                            if (order.email != null)
                              Text(order.email.toString()),
                            const SizedBox(height: 4.0),
                            Text(
                              order.shippingAddress ?? 'Address not available',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13.0,
                              ),
                            ),
                            if (order.orderNotes != null &&
                                order.orderNotes!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Note: ${order.orderNotes}',
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
                  if (order.statusHistory != null &&
                      order.statusHistory!.isNotEmpty)
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
                        _buildStatusTimeline(order.statusHistory!),
                      ],
                    ),

                  const SizedBox(height: 16.0),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Track order functionality
                        },
                        icon: const Icon(Icons.location_on_outlined),
                        label: const Text('Track Order'),
                      ),
                      const SizedBox(width: 12.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Support functionality
                        },
                        icon: const Icon(Icons.support_agent),
                        label: const Text('Get Support'),
                      ),
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

  Widget _buildErrorCard(String errorMsg) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32.0),
          const SizedBox(height: 8.0),
          Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.red[800],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(errorMsg, textAlign: TextAlign.center),
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
