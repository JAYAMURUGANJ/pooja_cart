import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pooja_cart/features/domain/entities/product/product_response.dart'
    show ProductUnit;
import 'package:pooja_cart/features/presentation/common_widgets/extensions.dart';
import 'package:pooja_cart/features/presentation/screens/admin/add_new_item/widgets/add_new_form/components/add_units_widget.dart';
import 'package:pooja_cart/features/presentation/screens/admin/add_new_item/widgets/add_new_form/components/select_category_widget.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/product/product_bloc.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/unit/unit_bloc.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart'
    show CommonRequestModel, ProductImage, Translation;
import '../../../../../../domain/entities/category/category_response.dart';
import '../../../../customer/home/bloc/category/category_bloc.dart';
import '../../cubit/image_picker/image_picker_cubit.dart';

class AddNewItemForm extends StatefulWidget {
  const AddNewItemForm({super.key});

  @override
  State<AddNewItemForm> createState() => _AddNewItemFormState();
}

class _AddNewItemFormState extends State<AddNewItemForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _tamilNameController = TextEditingController();
  final categoryNotifier = ValueNotifier<CategoryResponse?>(null);
  final unitNotifier = ValueNotifier<List<ProductUnit>?>(null);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ImagePickerCubit>(context).clearPickedImage(null);
    _formKey.currentState?.reset();
    BlocProvider.of<CategoryBloc>(
      context,
    ).add(GetCategoryEvent(CommonRequestModel()));
    BlocProvider.of<UnitBloc>(context).add(GetUnitsEvent(CommonRequestModel()));
  }

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
          return BlocListener<ProductBloc, ProductState>(
            listener: (context, productState) {
              switch (productState.status) {
                case ProductStatus.intial:
                  // Do nothing
                  break;
                case ProductStatus.loading:
                  context.showSnackBar(
                    message: "Loading...",
                    bgColor: Colors.lightBlue,
                  );
                  break;
                case ProductStatus.error:
                  context.showSnackBar(message: productState.errorMsg!);
                  break;
                case ProductStatus.loaded:
                  context.showSnackBar(message: "Product Created Successfully");
                  Navigator.pop(context);
                  break;
              }
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildImagePicker(xFile, context),
                      SelectCategoryWidget(
                        onCategorySelected: (selectedCategory) {
                          categoryNotifier.value = selectedCategory;
                        },
                      ),
                      _buildNameInformation(),
                      AddUnitsWidget(
                        onUnitAdded: (addedUnits) {
                          unitNotifier.value = addedUnits;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ImagePickerCubit, XFile?>(
        builder: (context, xFile) {
          return Container(
            height: 60,
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (xFile == null) {
                    return context.showSnackBar(
                      message: 'Please select an image',
                    );
                  }
                  if (categoryNotifier.value == null) {
                    return context.showSnackBar(
                      message: 'Please select a category',
                    );
                  }
                  if (unitNotifier.value == null ||
                      unitNotifier.value!.isEmpty) {
                    return context.showSnackBar(
                      message: 'Please add at least one unit',
                    );
                  }
                  BlocProvider.of<ProductBloc>(context).add(
                    CreateProductEvent(
                      CommonRequestModel(
                        categoryId: categoryNotifier.value!.id,
                        isActive: true,
                        images: [
                          ProductImage(
                            filePath: xFile.path,
                            isPrimary: true,
                            displayOrder: 1,
                          ),
                        ],
                        translations: [
                          Translation(
                            lang: "en",
                            name: _englishNameController.text,
                          ),
                          Translation(
                            lang: "ta",
                            name: _tamilNameController.text,
                          ),
                        ],
                        units: [],
                      ),
                    ),
                  );
                }
              },
              child: Text("Add Product"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameInformation() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Text("Product Name"),
            TextFormField(
              controller: _englishNameController,
              decoration: InputDecoration(
                hintText: "Enter product name in english",
                labelText: "Name (English)",
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
                labelText: "Name (Tamil)",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter product name";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(XFile? xFile, BuildContext context) {
    return BlocBuilder<ImagePickerCubit, XFile?>(
      builder: (context, xFile) {
        return FormField(
          initialValue: xFile,
          validator: (image) {
            if (image == null) {
              return 'Please select an image.';
            }
            return null;
          },
          builder: (FormFieldState<XFile?> field) {
            return Column(
              children: [
                Container(
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
                                    ).clearPickedImage(field);
                                  },
                                  shape: const CircleBorder(),
                                  color: Colors.black26,
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
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
                                  BlocProvider.of<ImagePickerCubit>(
                                    context,
                                  ).pickImage(field);
                                },
                                child: const Text("Add Image"),
                              ),
                            ],
                          ),
                ),
                // empty image error text
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
