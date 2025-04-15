import 'package:flutter/material.dart';
import 'package:pooja_cart/utils/responsive_utils.dart';

import 'widget/user_info_card.dart';
import 'widget/user_saved_address.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          context.isMobile || context.isTablet
              ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [UserInfoCard(), UserSavedAddress()],
                ),
              )
              : Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserInfoCard(),
                  UserSavedAddress(),
                  // context.isMobile || context.isTablet
                  //     ? Expanded(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [UserSavedAddress(), AddAddressForm()],
                  //       ),
                  //     )
                  //     : Expanded(
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [UserSavedAddress(), AddAddressForm()],
                  //       ),
                  //     ),
                ],
              ),
    );
  }
}
