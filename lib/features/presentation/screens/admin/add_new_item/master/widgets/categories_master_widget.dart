import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooja_cart/features/domain/entities/category/category_response.dart';

import '../../../../../../data/remote/model/request/common_request_model.dart';
import '../../../../customer/home/bloc/category/category_bloc.dart';

class CategoriesMasterWidget extends StatefulWidget {
  const CategoriesMasterWidget({super.key});

  @override
  State<CategoriesMasterWidget> createState() => _CategoriesMasterWidgetState();
}

class _CategoriesMasterWidgetState extends State<CategoriesMasterWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(
      context,
    ).add(GetCategoryEvent(CommonRequestModel()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
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
            return _buildLoadedWidget(state.categoryResponse!);
        }
      },
    );
  }

  ListView _buildLoadedWidget(List<CategoryResponse> categoriesList) {
    return ListView.separated(
      itemCount: categoriesList.length,
      separatorBuilder: (context, index) => DottedLine(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categoriesList[index].name!),
          subtitle: Text(
            categoriesList[index].units!.map((e) => e.name!).join(", "),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<CategoryBloc>(context).add(
                    DeleteCategoryEvent(
                      CommonRequestModel(categoryId: categoriesList[index].id),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
