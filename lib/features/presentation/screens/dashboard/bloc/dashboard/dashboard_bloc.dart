// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pooja_cart/features/data/remote/model/common_request_model.dart';
// import 'package:pooja_cart/features/domain/repositories/dashboard_repository.dart';

// // Events
// abstract class DashboardEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class FetchDashboardDataEvent extends DashboardEvent {
//   final CommonRequestModel requestModel;

//   FetchDashboardDataEvent(this.requestModel);

//   @override
//   List<Object?> get props => [requestModel];
// }

// // States
// abstract class DashboardState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class DashboardInitial extends DashboardState {}

// class DashboardLoading extends DashboardState {}

// class DashboardLoaded extends DashboardState {
//   final DashboardData dashboardData;

//   DashboardLoaded(this.dashboardData);

//   @override
//   List<Object?> get props => [dashboardData];
// }

// class DashboardError extends DashboardState {
//   final String message;

//   DashboardError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// // Data Classes
// class DashboardData {
//   final double todaySales;
//   final double totalStockValue;
//   final int newStockItems;
//   final int lowStockItems;
//   final double salesChangePercentage;
//   final double stockValueChangePercentage;
//   final List<SalesData> salesData;
//   final List<TopSellingItem> topSellingItems;
//   final List<RecentOrder> recentOrders;

//   DashboardData({
//     required this.todaySales,
//     required this.totalStockValue,
//     required this.newStockItems,
//     required this.lowStockItems,
//     required this.salesChangePercentage,
//     required this.stockValueChangePercentage,
//     required this.salesData,
//     required this.topSellingItems,
//     required this.recentOrders,
//   });
// }

// class SalesData {
//   final DateTime date;
//   final double sales;
//   final double profit;

//   SalesData({required this.date, required this.sales, required this.profit});
// }

// class TopSellingItem {
//   final int id;
//   final String name;
//   final String category;
//   final int quantitySold;
//   final double totalRevenue;
//   final String imageUrl;

//   TopSellingItem({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.quantitySold,
//     required this.totalRevenue,
//     required this.imageUrl,
//   });
// }

// class RecentOrder {
//   final String orderId;
//   final String customerName;
//   final DateTime orderDate;
//   final double totalAmount;
//   final String status;
//   final int itemCount;

//   RecentOrder({
//     required this.orderId,
//     required this.customerName,
//     required this.orderDate,
//     required this.totalAmount,
//     required this.status,
//     required this.itemCount,
//   });
// }

// // Bloc Implementation
// class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
//   final DashboardRepository dashboardRepository;

//   DashboardBloc({required this.dashboardRepository})
//     : super(DashboardInitial()) {
//     on<FetchDashboardDataEvent>(_onFetchDashboardData);
//   }

//   Future<void> _onFetchDashboardData(
//     FetchDashboardDataEvent event,
//     Emitter<DashboardState> emit,
//   ) async {
//     emit(DashboardLoading());
//     try {
//       final dashboardData = await dashboardRepository.getDashboardData(
//         event.requestModel,
//       );
//       emit(DashboardLoaded(dashboardData));
//     } catch (e) {
//       emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
//     }
//   }
// }
