import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:pooja_cart/features/presentation/screens/cart/bloc/category/category_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/cart/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/cart/bloc/unit/unit_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/cart/cubit/unit_selection/unit_selection_cubit.dart';
import 'package:pooja_cart/features/presentation/ui/bloc/theme/theme_cubit.dart';

import 'di/di_module.dart';

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
    ];
  }
}
