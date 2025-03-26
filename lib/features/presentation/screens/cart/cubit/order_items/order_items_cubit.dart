import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';

part 'order_items_state.dart';

class OrderItemsCubit extends Cubit<OrderItemsState> {
  OrderItemsCubit() : super(OrderItemsState(orderItems: []));

  void addOrderItem(OrderItems item) {
    final updatedItems = List<OrderItems>.from(state.orderItems);

    // Check if the item with the same ID and unitId already exists
    final existingIndex = updatedItems.indexWhere(
      (element) => element.id == item.id && element.unitId == item.unitId,
    );

    if (existingIndex == -1) {
      // Add new item if not found
      updatedItems.add(item);
    }

    emit(
      state.copyWith(
        status: OrderItemsStatus.updated,
        orderItems: updatedItems,
      ),
    );
  }

  void removeOrderItem(int productId, int unitId) {
    final updatedItems =
        state.orderItems
            .where((item) => !(item.id == productId && item.unitId == unitId))
            .toList();

    emit(
      state.copyWith(
        status: OrderItemsStatus.updated,
        orderItems: updatedItems,
      ),
    );
  }

  // ✅ New method to update quantity
  void updateQuantity(int productId, int unitId, int newQuantity) {
    final updatedItems =
        state.orderItems.map((item) {
          if (item.id == productId && item.unitId == unitId) {
            return OrderItems(
              id: item.id,
              name: item.name,
              unitId: item.unitId,
              quantity: newQuantity, // Update quantity
            );
          }
          return item;
        }).toList();

    emit(
      state.copyWith(
        status: OrderItemsStatus.updated,
        orderItems: updatedItems,
      ),
    );
  }
}
