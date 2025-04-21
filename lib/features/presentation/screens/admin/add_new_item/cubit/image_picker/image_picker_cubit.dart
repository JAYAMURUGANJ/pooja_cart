import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

class ImagePickerCubit extends Cubit<XFile?> {
  ImagePickerCubit() : super(null);

  pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    emit(image);
  }

  clearPickedImage() async {
    emit(null);
  }
}
