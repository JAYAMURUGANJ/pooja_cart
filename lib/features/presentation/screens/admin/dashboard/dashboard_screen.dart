import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/admin/dashboard/bloc/admin_dashboard_data/admin_dashboard_data_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/admin/dashboard/widgets/welcome_section.dart';

import '../../../../data/remote/model/request/common_request_model.dart';
import '../../../../domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';
import 'widgets/metrics_section.dart';
import 'widgets/products_info_section.dart';
import 'widgets/recent_orders_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminDashboardDataBloc>(
      context,
    ).add(GetDashboardDataEvent(requestData: CommonRequestModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminDashboardDataBloc, AdminDashboardDataState>(
        builder: (context, state) {
          switch (state.status) {
            case AdminDashboardDataStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case AdminDashboardDataStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case AdminDashboardDataStatus.error:
              return Center(
                child: Text(
                  state.errorMsg ?? 'Something went wrong',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            case AdminDashboardDataStatus.loaded:
              return _buildSuccessWidget(context, state.dashboardResponse!);
          }
        },
      ),
    );
  }

  SingleChildScrollView _buildSuccessWidget(
    BuildContext context,
    AdminDashboardResponse dashboardData,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 24,
          mainAxisSize: MainAxisSize.min,
          children: [
            WelcomeSection(adminUser: dashboardData.adminUser),
            MetricsSection(metrics: dashboardData.metrics!),
            RecentOrdersSection(recentOrders: dashboardData.recentOrders),
            ProductsInfoSection(products: dashboardData.products),
          ],
        ),
      ),
    );
  }
}
