import '../../domain/entities/order_items/order_items.dart';

class OrderCalculationHelper {
  final List<OrderItems> items;

  OrderCalculationHelper(this.items);

  double get subtotal => items.fold(
    0,
    (sum, item) => sum + ((item.mrp ?? 0) * (item.quantity ?? 0)),
  );

  double get discount => items.fold(
    0,
    (sum, item) =>
        sum +
        (((item.mrp ?? 0) - (item.sellingPrice ?? 0)) * (item.quantity ?? 0)),
  );

  double get total => subtotal - discount;

  double get mrpTotal => items.fold(
    0,
    (sum, item) => sum + ((item.mrp ?? 0) * (item.quantity ?? 0)),
  );

  double get discountPercentage =>
      mrpTotal > 0 ? (discount / mrpTotal) * 100 : 0;
}
