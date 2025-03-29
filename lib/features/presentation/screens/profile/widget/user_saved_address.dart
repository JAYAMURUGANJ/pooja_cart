import 'package:flutter/material.dart';
import 'package:pooja_cart/features/presentation/screens/profile/widget/add_address_form.dart';

class UserSavedAddress extends StatelessWidget {
  const UserSavedAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Saved Address",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AddAddressForm(),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add New"),
                ),
              ],
            ),
            Flexible(
              child: ListView.separated(
                separatorBuilder:
                    (context, index) =>
                        Divider(thickness: 0.5, indent: 16, endIndent: 16),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Dhinakaran"),
                    subtitle: Text(
                      "+91 98765 43210\n123, 4th Street, Anna Nagar Chennai, Tamil Nadu - 600040 India",
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text("Edit"), onTap: () {}),
                          PopupMenuItem(child: Text("Delete"), onTap: () {}),
                        ];
                      },
                    ),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
