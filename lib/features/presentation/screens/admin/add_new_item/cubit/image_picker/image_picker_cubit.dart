import 'package:flutter/src/widgets/form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<XFile?> {
  ImagePickerCubit() : super(null);

  final ImagePicker picker = ImagePicker();
  pickImage(FormFieldState<XFile?> field) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    emit(image);
    field.didChange(image);
  }

  clearPickedImage(FormFieldState<XFile?>? field) async {
    emit(null);
    field?.didChange(null);
  }
}
