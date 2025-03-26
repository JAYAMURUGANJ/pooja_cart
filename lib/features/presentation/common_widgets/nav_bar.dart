// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/items.dart';
import '../../../models/pooja_items.dart';
import '../screens/cart/widgets/search_bar.dart';
import '../ui/app_theme.dart';

typedef NavItemRecord = ({IconData icon, String text, String route});

class NavItem {
  final IconData icon;
  final String text;
  final String route;

  const NavItem({required this.icon, required this.text, required this.route});

  NavItem.fromRecord(NavItemRecord record)
    : icon = record.icon,
      text = record.text,
      route = record.route;
}

final navItems = [
  NavItem.fromRecord((
    icon: Icons.shopping_cart_outlined,
    text: 'Cart',
    route: '/',
  )),

  NavItem.fromRecord((
    icon: Icons.contact_mail,
    text: 'Contact',
    route: '/contact',
  )),
];

class WebNavBar extends StatefulWidget {
  final String currentRoute;
  final bool showSearchBar;
  final Function(PoojaItems)? onItemSelected; // Add this callback

  const WebNavBar({
    super.key,
    required this.currentRoute,
    this.showSearchBar = true,
    this.onItemSelected, // Add this parameter
  });

  @override
  State<WebNavBar> createState() => _WebNavBarState();
}

class _WebNavBarState extends State<WebNavBar> {
  final List<PoojaItems> pItems = PoojaItems.fromJsonList(poojaItems);
  final TextEditingController searchController = TextEditingController();

  // Define itemQuantities as a class property
  final Map<int, int> itemQuantities = {};

  void addItemToCart(PoojaItems item) {
    // Call the parent callback if provided
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    } else {
      // Fallback to local state if needed
      setState(() {
        int currentQuantity = itemQuantities[item.id] ?? 0;
        itemQuantities[item.id!] = currentQuantity + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(children: [SizedBox(height: 10), AppTitle()]),
          Visibility(
            visible: widget.showSearchBar,
            child: Expanded(
              child: ItemSearchAnchor(
                allItems: /* pItems */ [],
                onSearch: (query) {
                  setState(() {});
                },
                onItemSelected: addItemToCart, // Use the local method
                searchController: searchController,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  navItems
                      .map((item) => _WebNavItem(item, widget.currentRoute))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebNavItem extends StatelessWidget {
  final NavItem item;
  final String currentRoute;
  const _WebNavItem(this.item, this.currentRoute);

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == item.route;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () => context.go(item.route),
        style: AppTheme().getAdaptiveButtonStyle(
          context,
          isSelected: isSelected,
          defaultTextStyle: AppTypography().appMenuStyle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color:
                  isSelected
                      ? theme.colorScheme.primaryContainer
                      : AppTypography().appMenuStyle.color,
            ),
            const SizedBox(width: 10),
            Text(
              item.text,
              style:
                  isSelected
                      ? AppTypography().appMenuStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                      : AppTypography().appMenuStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/icons/icon.png", width: 50),
          const SizedBox(width: 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("S.Palani Store", style: AppTypography().appTitleStyle),
              Text(
                "way to buy a pooja-related items",
                style: AppTypography().appSubTitleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
