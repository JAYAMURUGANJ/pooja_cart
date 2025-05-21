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

  Widget _buildLoadedWidget(List<CategoryResponse> categoriesList) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive design based on screen width
        if (constraints.maxWidth > 900) {
          // Desktop layout - grid view
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categoriesList[index], index);
            },
          );
        } else if (constraints.maxWidth > 600) {
          // Tablet layout - 2 columns
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categoriesList[index], index);
            },
          );
        } else {
          // Mobile layout - list view
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              return _buildCategoryListItem(categoriesList[index], index);
            },
          );
        }
      },
    );
  }

  Widget _buildCategoryCard(CategoryResponse category, int index) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editCategory(category, index),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCategory(index),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('ID: ${category.id}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text(
              'Units:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: category.units!.length,
                itemBuilder: (context, unitIndex) {
                  final unit = category.units![unitIndex];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(unit.name!),
                    subtitle: Text('${unit.abbreviation} (ID: ${unit.id})'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(CategoryResponse category, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Text(
          category.name!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('ID: ${category.id}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editCategory(category, index),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteCategory(index),
              tooltip: 'Delete',
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Units:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: category.units!.length,
                  itemBuilder: (context, unitIndex) {
                    final unit = category.units![unitIndex];
                    return ListTile(
                      dense: true,
                      title: Text(unit.name!),
                      subtitle: Text('${unit.abbreviation} (ID: ${unit.id})'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editCategory(CategoryResponse category, int index) async {
    final result = await showDialog<CategoryResponse>(
      context: context,
      builder: (context) => Text("result"),
      //  CategoryDialog(category: category),
    );

    if (result != null) {
      setState(() {
        category = result;
      });
    }
  }

  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Category'),
            content: Text(
              'Are you sure you want to delete "${"_categories[index].name"}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('Delete'),
              ),
            ],
          ),
    );
  }
}
