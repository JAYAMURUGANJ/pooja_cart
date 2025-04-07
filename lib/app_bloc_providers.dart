import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:pooja_cart/features/presentation/screens/confirm_order/bloc/place_order/place_order_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/bloc/unit/unit_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/home/cubit/category_filter_selection/category_filter_selection_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/home/cubit/order_items/order_items_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/home/cubit/unit_filter_selection/unit_filter_selection_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/home/cubit/unit_selection/unit_selection_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/my_orders/bloc/my_orders/my_orders_bloc.dart';
import 'package:pooja_cart/features/presentation/ui/bloc/theme/theme_cubit.dart';

import 'di/di_module.dart';
import 'features/presentation/screens/home/cubit/product_filter/product_filter_cubit.dart';

class AppBlocProviders {
  static List<SingleChildWidget> get providers {
    return [
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      BlocProvider<UnitBloc>(create: (context) => UnitBloc(sl())),
      BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(sl())),
      BlocProvider<ProductBloc>(create: (context) => ProductBloc(sl())),
      BlocProvider<UnitSelectionCubit>(
        create: (context) => UnitSelectionCubit(),
      ),
      BlocProvider<OrderItemsCubit>(create: (context) => OrderItemsCubit()),
      BlocProvider<PlaceOrderBloc>(create: (context) => PlaceOrderBloc(sl())),
      BlocProvider<MyOrdersBloc>(create: (context) => MyOrdersBloc(sl(), sl())),
      BlocProvider<UnitFilterSelectionCubit>(
        create: (context) => UnitFilterSelectionCubit(),
      ),
      BlocProvider<CategoryFilterSelectionCubit>(
        create: (context) => CategoryFilterSelectionCubit(),
      ),
      BlocProvider<ProductFilterCubit>(
        create: (context) => ProductFilterCubit(),
      ),
    ];
  }
}
