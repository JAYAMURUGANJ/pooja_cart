import 'package:bloc/bloc.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';

part 'order_items_state.dart';

class OrderItemsCubit extends Cubit<OrderItemsState> {
  OrderItemsCubit() : super(OrderItemsState(orderItems: []));

  void addOrderItem(int productId, String unit) {
    final updatedCart = List<OrderItems>.from(state.orderItems);

    // Check if the product with the same variant exists
    final existingItemIndex = updatedCart.indexWhere(
      (item) => item.id == productId && item.name == unit,
    );

    if (existingItemIndex != -1) {
      // If exists, increase quantity
      updatedCart[existingItemIndex] = updatedCart[existingItemIndex];
    } else {
      // If not exists, add new item
      updatedCart.add(OrderItems(id: productId, name: unit, unitId: 1));
    }

    emit(state.copyWith(orderItems: updatedCart));
  }

  void removeOrderItem(int productId, int unitId) {
    final updatedCart = List<OrderItems>.from(state.orderItems);

    final existingItemIndex = updatedCart.indexWhere(
      (item) => item.unitId == productId && item.unitId == unitId,
    );

    if (existingItemIndex != -1) {
      final existingItem = updatedCart[existingItemIndex];

      // if (existingItem.quantity > 1) {
      //   updatedCart[existingItemIndex] = existingItem.copyWith(
      //     quantity: existingItem.quantity - 1,
      //   );
    } else {
      updatedCart.removeAt(existingItemIndex);
    }

    emit(state.copyWith(orderItems: updatedCart));
  }
}
