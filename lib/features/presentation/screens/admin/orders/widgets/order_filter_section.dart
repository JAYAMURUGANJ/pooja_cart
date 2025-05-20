import 'package:flutter/material.dart';
import 'package:pooja_cart/features/domain/entities/admin/admin_orders/admin_orders_response.dart';

class OrderFilterSection extends StatefulWidget {
  const OrderFilterSection({super.key});

  @override
  State<OrderFilterSection> createState() => _OrderFilterSectionState();
}

class _OrderFilterSectionState extends State<OrderFilterSection> {
  late Future<AdminOrdersResponse> _ordersData;
  int _currentPage = 1;
  final int _limit = 10;
  String _searchQuery = '';
  String _filterStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by order ID or customer name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                                _applyFilters();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (_) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                label: const Text('Apply'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: _applyFilters,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', _filterStatus == 'All'),
                _buildFilterChip('Pending', _filterStatus == 'Pending'),
                _buildFilterChip('Processing', _filterStatus == 'Processing'),
                _buildFilterChip('Shipped', _filterStatus == 'Shipped'),
                _buildFilterChip('Delivered', _filterStatus == 'Delivered'),
                _buildFilterChip('Cancelled', _filterStatus == 'Cancelled'),
                _buildFilterChip('Returned', _filterStatus == 'Returned'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _currentPage = 1;
      // _ordersData = fetchOrders(1);
    });
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterStatus = selected ? label : 'All';
          });
          _applyFilters();
        },

        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
