import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/image_picker/image_picker_cubit.dart';

class AddNewItemForm extends StatefulWidget {
  const AddNewItemForm({super.key});

  @override
  State<AddNewItemForm> createState() => _AddNewItemFormState();
}

class _AddNewItemFormState extends State<AddNewItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _categoryDropDownKey = GlobalKey<DropdownSearchState>();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _tamilNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 8,
        centerTitle: true,
        title: Text(
          "Add New Item",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [CloseButton()],
      ),
      body: BlocBuilder<ImagePickerCubit, XFile?>(
        builder: (context, xFile) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // (xFile == null &&
                  //       (widget.forUpdate &&
                  //           widget.item!.itemImage != null &&
                  //           widget.item!.itemImage!.isNotEmpty))
                  //   ? Stack(
                  //       children: [
                  //         NetworkImageWidget(
                  //           url: widget.item!.itemImage!,
                  //           borderRadius: 12,
                  //           height: 250,
                  //         ),
                  //         Positioned(
                  //             top: 5,
                  //             right: 5,
                  //             child: IconButton.filled(
                  //                 onPressed: () {
                  //                   BlocProvider.of<ImagePickerCubit>(context)
                  //                       .pickImage();
                  //                 },
                  //                 icon: const Icon(Icons.edit))),
                  //       ],
                  //     )
                  //   :
                  _buildImagePicker(xFile, context),
                  TextFormField(
                    controller: _englishNameController,
                    decoration: InputDecoration(
                      hintText: "Enter product name in english",
                      labelText: "Product Name (English)",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product name";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tamilNameController,
                    decoration: InputDecoration(
                      hintText: "Enter product name in tamil",
                      labelText: "Product Name (Tamil)",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product name";
                      }
                      return null;
                    },
                  ),
                  DropdownSearch<String>(
                    key: _categoryDropDownKey,
                    selectedItem: "Menu",
                    items:
                        (filter, infiniteScrollProps) => [
                          "Menu",
                          "Dialog",
                          "Modal",
                          "BottomSheet",
                        ],
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: Text("Add Product"),
        ),
      ),
    );
  }

  Container _buildImagePicker(XFile? xFile, BuildContext context) {
    return Container(
      height: 250,
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: .15),
      ),
      child:
          xFile != null
              ? Stack(
                alignment: Alignment.topCenter,
                children: [
                  kIsWeb
                      ? Image.network(
                        xFile.path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                      : Image.file(
                        File(xFile.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {
                        BlocProvider.of<ImagePickerCubit>(
                          context,
                        ).clearPickedImage();
                      },
                      shape: const CircleBorder(),
                      color: Colors.black26,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              )
              : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.photo,
                    size: 180,
                    color: Colors.grey.shade300,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      BlocProvider.of<ImagePickerCubit>(context).pickImage();
                    },
                    child: const Text("Add Image"),
                  ),
                ],
              ),
    );
  }
}
