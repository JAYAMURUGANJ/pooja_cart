import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:pooja_cart/bloc/theme/theme_cubit.dart';

class AppBlocProviders {
  static List<SingleChildWidget> get providers {
    return [BlocProvider<ThemeCubit>(create: (context) => ThemeCubit())];
  }
}
