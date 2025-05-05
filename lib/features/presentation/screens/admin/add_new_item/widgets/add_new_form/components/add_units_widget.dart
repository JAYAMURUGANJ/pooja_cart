import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';
import 'package:pooja_cart/features/presentation/common_widgets/alert_widgets.dart';
import 'package:pooja_cart/features/presentation/screens/admin/add_new_item/cubit/add_units/add_units_cubit.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/unit/unit_bloc.dart';

import '../../../../../../../data/remote/model/request/common_request_model.dart'
    show CommonRequestModel;
import '../../../../../../../domain/entities/product/product_response.dart';

class AddUnitsWidget extends StatefulWidget {
  final Function(List<ProductUnit>) onUnitAdded;
  const AddUnitsWidget({super.key, required this.onUnitAdded});

  @override
  State<AddUnitsWidget> createState() => _AddUnitsWidgetState();
}

class _AddUnitsWidgetState extends State<AddUnitsWidget> {
  final _unitFormKey = GlobalKey<FormState>();
  final _unitDropDownKey = GlobalKey<DropdownSearchState>();
  UnitResponse? selectedUnit;

  final TextEditingController _conversionFactorController =
      TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  @override
  void dispose() {
    _conversionFactorController.dispose();
    _mrpController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddUnitsCubit, List<ProductUnit>>(
      listener: (context, addedUnits) {
        widget.onUnitAdded(addedUnits);
      },
      builder: (context, addedUnits) {
        return Card(
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  "Unit Information",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (addedUnits.isNotEmpty) ...[
                  const Text(
                    'Added Units',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addedUnits.length,
                    itemBuilder: (context, index) {
                      final unit = addedUnits[index];
                      return ListTile(
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "unit: "),
                              TextSpan(text: "${unit.conversionFactor} "),
                              TextSpan(text: "${unit.abbreviation}\n"),
                              TextSpan(text: "Mrp: "),
                              TextSpan(text: "${unit.mrp}\n"),
                              TextSpan(text: "selling price: "),
                              TextSpan(text: "${unit.sellingPrice}\n"),
                              TextSpan(text: "Stock: "),
                              TextSpan(text: "${unit.inStock}\n"),
                            ],
                          ),
                        ),

                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            AlertWidgets(context).showCommonAlertDialog(
                              content: "Remove unit",
                              actionBtnTxt: "Remove",
                              action: () {
                                context.read<AddUnitsCubit>().removeUnit(
                                  addedUnits[index],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
                BlocBuilder<UnitBloc, UnitState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case UnitStatus.intial:
                        return Row(
                          children: [
                            Text("Units not Loaded"),
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<UnitBloc>(
                                  context,
                                ).add(GetUnitsEvent(CommonRequestModel()));
                              },
                              icon: Icon(Icons.refresh),
                            ),
                          ],
                        );
                      case UnitStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case UnitStatus.error:
                        return Center(child: Text(state.errorMsg!));
                      case UnitStatus.loaded:
                        List<UnitResponse> unitsList = state.unitResponse!;
                        return Form(
                          key: _unitFormKey,
                          child: Column(
                            spacing: 16,
                            children: [
                              DropdownSearch<UnitResponse>(
                                key: _unitDropDownKey,
                                onChanged: (value) => selectedUnit = value,
                                items: (filter, loadProps) => unitsList,
                                compareFn:
                                    (item1, item2) => item1.id == item2.id,
                                itemAsString:
                                    (UnitResponse item) =>
                                        "${item.name!} (${item.abbreviation})",
                                validator:
                                    (value) =>
                                        value == null
                                            ? 'Please select a unit'
                                            : null,
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: 'Unit',
                                    hintText: 'Select unit',
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                ),
                                popupProps: PopupPropsMultiSelection.dialog(
                                  showSearchBox: true,
                                  listViewProps: ListViewProps(),
                                  fit: FlexFit.loose,
                                ),
                              ),
                              TextFormField(
                                controller: _conversionFactorController,
                                decoration: const InputDecoration(
                                  labelText: 'Weight',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter weight';
                                  }
                                  final doubleValue = double.tryParse(value);
                                  if (doubleValue == null || doubleValue < 0) {
                                    return 'Please enter a valid weight';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _mrpController,
                                decoration: const InputDecoration(
                                  labelText: 'MRP',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter MRP';
                                  }
                                  final doubleValue = double.tryParse(value);
                                  if (doubleValue == null || doubleValue < 0) {
                                    return 'Please enter a valid MRP';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _sellingPriceController,
                                decoration: const InputDecoration(
                                  labelText: 'Selling Price',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter selling price';
                                  }
                                  final doubleValue = double.tryParse(value);
                                  if (doubleValue == null || doubleValue < 0) {
                                    return 'Please enter a valid selling price';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _stockController,
                                decoration: const InputDecoration(
                                  labelText: 'Stock',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter stock';
                                  }
                                  final intValue = int.tryParse(value);
                                  if (intValue == null || intValue < 0) {
                                    return 'Please enter a valid stock';
                                  }
                                  return null;
                                },
                              ),
                              Center(
                                child: FilledButton.icon(
                                  onPressed: () {
                                    if (_unitFormKey.currentState!.validate()) {
                                      BlocProvider.of<AddUnitsCubit>(
                                        context,
                                      ).addUnit(
                                        ProductUnit(
                                          unitId: selectedUnit?.id,
                                          name: selectedUnit?.name,
                                          abbreviation:
                                              selectedUnit?.abbreviation,
                                          conversionFactor: int.tryParse(
                                            _conversionFactorController.text,
                                          ),
                                          mrp: double.tryParse(
                                            _mrpController.text,
                                          ),
                                          sellingPrice: double.tryParse(
                                            _sellingPriceController.text,
                                          ),
                                          inStock: int.tryParse(
                                            _stockController.text,
                                          ),
                                        ),
                                      );
                                      _resetForm();
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Unit'),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _resetForm() {
    _unitDropDownKey.currentState?.clear();
    _conversionFactorController.clear();
    _mrpController.clear();
    _sellingPriceController.clear();
    _stockController.clear();
    selectedUnit = null;
  }
}
