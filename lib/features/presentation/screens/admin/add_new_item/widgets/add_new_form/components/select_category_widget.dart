import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../../../../domain/entities/category/category_response.dart';
import '../../../../../customer/home/bloc/category/category_bloc.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Function(CategoryResponse?)? onCategorySelected;
  const SelectCategoryWidget({super.key, required this.onCategorySelected});

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  final _categoryDropDownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Text("Basic Product Information"),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                switch (state.status) {
                  case CategoryStatus.intial:
                    return Center(
                      child: Row(
                        children: [
                          Text("Category not Loaded"),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<CategoryBloc>(
                                context,
                              ).add(GetCategoryEvent(CommonRequestModel()));
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    );
                  case CategoryStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case CategoryStatus.error:
                    return Center(child: Text(state.errorMsg!));
                  case CategoryStatus.loaded:
                    List<CategoryResponse> categoriesList =
                        state.categoryResponse!;
                    return DropdownSearch<CategoryResponse>(
                      key: _categoryDropDownKey,
                      selectedItem: null,
                      onChanged: (value) => widget.onCategorySelected!(value),
                      items: (filter, loadProps) => categoriesList,
                      compareFn: (item1, item2) => item1.id == item2.id,
                      itemAsString: (CategoryResponse item) => item.name!,
                      validator:
                          (value) =>
                              value == null ? 'Please select a category' : null,
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          hintText: 'Select Category',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        listViewProps: ListViewProps(),
                        fit: FlexFit.loose,
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
