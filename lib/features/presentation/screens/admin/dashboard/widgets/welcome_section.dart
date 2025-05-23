import 'package:flutter/material.dart';

import '../../../../../domain/entities/admin/admin_dashboard/admin_dashboard_response.dart';

class WelcomeSection extends StatelessWidget {
  final AdminUser? adminUser;
  const WelcomeSection({super.key, this.adminUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Welcome back, ${adminUser?.name}\n",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Here's what's happening in your store",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
