import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/unit/unit_response.dart';
import 'package:pooja_cart/features/presentation/screens/customer/home/bloc/unit/unit_bloc.dart';

import '../../../../../data/remote/model/request/common_request_model.dart';

class UnitMasterWidget extends StatefulWidget {
  const UnitMasterWidget({super.key});

  @override
  State<UnitMasterWidget> createState() => _UnitMasterWidgetState();
}

class _UnitMasterWidgetState extends State<UnitMasterWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitBloc, UnitState>(
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
            return _buildLoadedWidget(state.unitResponse!);
        }
      },
    );
  }

  Widget _buildLoadedWidget(List<UnitResponse> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index].name!),
          subtitle: Text(list[index].abbreviation!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle delete action
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
