// Model to represent cart items
import 'package:pooja_cart/models/pooja_items.dart';

class CartItem {
  final PoojaItems item;
  final int quantity;

  CartItem({required this.item, required this.quantity});

  double get totalPrice => (item.sellingPrice! * quantity).toDouble();
  double get totalDiscount =>
      ((item.mrp! - item.sellingPrice!) * quantity).toDouble();
}
