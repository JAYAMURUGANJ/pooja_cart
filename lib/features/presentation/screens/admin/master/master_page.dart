import 'package:flutter/material.dart';
import 'package:pooja_cart/features/presentation/screens/admin/master/widgets/category/categories_master_widget.dart';

import 'widgets/unit_master_widget.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [Tab(text: 'Categories'), Tab(text: 'Units')],
          ),
          Expanded(
            child: TabBarView(
              children: [CategoriesMasterWidget(), UnitMasterWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
