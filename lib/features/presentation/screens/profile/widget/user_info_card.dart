import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          !(context.isMobile || context.isTablet) ? Colors.grey.shade100 : null,
      constraints: BoxConstraints.tight(
        Size(
          400,
          context.isMobile || context.isTablet
              ? 280
              : MediaQuery.of(context).size.height,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: [
            CircleAvatar(radius: 48, child: Icon(Icons.person, size: 56)),
            SizedBox(height: 10),
            Text("Dhinakaran", style: Theme.of(context).textTheme.titleLarge),
            Text(
              "+91 8220922365",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
