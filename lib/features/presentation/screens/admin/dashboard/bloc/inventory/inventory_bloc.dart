// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pooja_cart/features/data/remote/model/common_request_model.dart';
// import 'package:pooja_cart/features/domain/repositories/inventory_repository.dart';

// // Events
// abstract class InventoryEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class FetchInventoryStatusEvent extends InventoryEvent {
//   final CommonRequestModel requestModel;

//   FetchInventoryStatusEvent(this.requestModel);

//   @override
//   List<Object?> get props => [requestModel];
// }

// class AddStockEvent extends InventoryEvent {
//   final int itemId;
//   final double quantity;
//   final double costPrice;

//   AddStockEvent({
//     required this.itemId,
//     required this.quantity,
//     required this.costPrice,
//   });

//   @override
//   List<Object?> get props => [itemId, quantity, costPrice];
// }

// class UpdateProductEvent extends InventoryEvent {
//   final int productId;
//   final Map<String, dynamic> productData;

//   UpdateProductEvent({required this.productId, required this.productData});

//   @override
//   List<Object?> get props => [productId, productData];
// }

// // States
// abstract class InventoryState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class InventoryInitial extends InventoryState {}

// class InventoryLoading extends InventoryState {}

// class InventoryLoaded extends InventoryState {
//   final InventoryData inventoryData;

//   InventoryLoaded(this.inventoryData);

//   @override
//   List<Object?> get props => [inventoryData];
// }

// class InventoryOperationSuccess extends InventoryState {
//   final String message;

//   InventoryOperationSuccess(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class InventoryError extends InventoryState {
//   final String message;

//   InventoryError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// // Data Class
// class InventoryData {
//   final List<StockItem> stockItems;
//   final List<LowStockItem> lowStockItems;
//   final double totalStockValue;
//   final int totalItems;

//   InventoryData({
//     required this.stockItems,
//     required this.lowStockItems,
//     required this.totalStockValue,
//     required this.totalItems,
//   });
// }

// class StockItem {
//   final int id;
//   final String name;
//   final String category;
//   final String unit;
//   final double quantity;
//   final double costPrice;
//   final double sellingPrice;
//   final double value;

//   StockItem({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.unit,
//     required this.quantity,
//     required this.costPrice,
//     required this.sellingPrice,
//     required this.value,
//   });
// }

// class LowStockItem {
//   final int id;
//   final String name;
//   final String category;
//   final double currentStock;
//   final double minimumStock;
//   final double reorderLevel;

//   LowStockItem({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.currentStock,
//     required this.minimumStock,
//     required this.reorderLevel,
//   });
// }

// // Bloc Implementation
// class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
//   final InventoryRepository inventoryRepository;

//   InventoryBloc({required this.inventoryRepository})
//     : super(InventoryInitial()) {
//     on<FetchInventoryStatusEvent>(_onFetchInventoryStatus);
//     on<AddStockEvent>(_onAddStock);
//     on<UpdateProductEvent>(_onUpdateProduct);
//   }

//   Future<void> _onFetchInventoryStatus(
//     FetchInventoryStatusEvent event,
//     Emitter<InventoryState> emit,
//   ) async {
//     emit(InventoryLoading());
//     try {
//       final inventoryData = await inventoryRepository.getInventoryStatus(
//         event.requestModel,
//       );
//       emit(InventoryLoaded(inventoryData));
//     } catch (e) {
//       emit(InventoryError('Failed to load inventory data: ${e.toString()}'));
//     }
//   }

//   Future<void> _onAddStock(
//     AddStockEvent event,
//     Emitter<InventoryState> emit,
//   ) async {
//     emit(InventoryLoading());
//     try {
//       await inventoryRepository.addStock(
//         itemId: event.itemId,
//         quantity: event.quantity,
//         costPrice: event.costPrice,
//       );

//       // Refresh inventory data after adding stock
//       final inventoryData = await inventoryRepository.getInventoryStatus(
//         CommonRequestModel(),
//       );

//       emit(InventoryLoaded(inventoryData));
//     } catch (e) {
//       emit(InventoryError('Failed to add stock: ${e.toString()}'));
//     }
//   }

//   Future<void> _onUpdateProduct(
//     UpdateProductEvent event,
//     Emitter<InventoryState> emit,
//   ) async {
//     emit(InventoryLoading());
//     try {
//       await inventoryRepository.updateProduct(
//         productId: event.productId,
//         productData: event.productData,
//       );

//       // Refresh inventory data after updating product
//       final inventoryData = await inventoryRepository.getInventoryStatus(
//         CommonRequestModel(),
//       );

//       emit(InventoryLoaded(inventoryData));
//     } catch (e) {
//       emit(InventoryError('Failed to update product: ${e.toString()}'));
//     }
//   }
// }
