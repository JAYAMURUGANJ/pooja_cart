import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PageNavigationCubit extends Cubit<int> {
  PageNavigationCubit() : super(0);
  changePage(int index) {
    emit(index);
  }
}
