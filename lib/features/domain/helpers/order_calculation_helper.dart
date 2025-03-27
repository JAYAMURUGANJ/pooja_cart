import '../entities/order_items/order_items.dart';

class OrderCalculationHelper {
  final List<OrderItems> items;

  OrderCalculationHelper(this.items);

  int get subtotal => items.fold(
    0,
    (sum, item) => sum + ((item.mrp ?? 0) * (item.quantity ?? 0)),
  );

  int get discount => items.fold(
    0,
    (sum, item) =>
        sum +
        (((item.mrp ?? 0) - (item.sellingPrice ?? 0)) * (item.quantity ?? 0)),
  );

  int get total => subtotal - discount;

  int get mrpTotal => items.fold(
    0,
    (sum, item) => sum + ((item.mrp ?? 0) * (item.quantity ?? 0)),
  );

  double get discountPercentage =>
      mrpTotal > 0 ? (discount / mrpTotal) * 100 : 0;
}
