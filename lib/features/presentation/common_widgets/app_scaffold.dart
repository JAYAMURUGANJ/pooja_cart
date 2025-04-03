import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/presentation/common_widgets/nav_bar.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const AppScaffold({super.key, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: child);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final isDesktopOrWeb = context.isDesktop;
    return AppBar(
      toolbarHeight: context.responsiveValue(mobile: 70.0, desktop: 80.0),
      title:
          isDesktopOrWeb ? WebNavBar(onItemSelected: (value) {}) : AppTitle(),
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      actions: [
        //
        if (context.isMobile)
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.responsiveIconSize,
              color:
                  /*  (itemQuantities.isNotEmpty)
                      ? Colors.red.shade400
                      :  */
                  Colors.grey.shade400,
            ),
            onPressed:
                /* (itemQuantities.isNotEmpty)
                    ? () {
                      ProductUtils.showClearCartDialog(context, () {});
                    }
                    :  */
                null,
          ),
      ],
    );
  }
}
