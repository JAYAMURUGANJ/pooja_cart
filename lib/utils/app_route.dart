import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/presentation/screens/cart/cart_screen.dart';

import '../features/presentation/screens/contact/contact_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: CartScreen()),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder:
          (context, state) => NoTransitionPage(child: const ContactPage()),
    ),
  ],
);
