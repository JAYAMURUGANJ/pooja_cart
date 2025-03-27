import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:pooja_cart/features/presentation/screens/home/home_screen.dart';
import 'package:pooja_cart/features/presentation/screens/order_summary/order_summary_screen.dart';
import 'package:pooja_cart/features/presentation/screens/profile/profile_screen.dart';

import 'features/presentation/screens/contact/contact_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder:
          (context, state) => NoTransitionPage(child: const ContactPage()),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder:
          (context, state) => NoTransitionPage(child: const DashboardScreen()),
    ),
    GoRoute(
      path: '/cart',
      pageBuilder:
          (context, state) =>
              NoTransitionPage(child: const OrderSummaryScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder:
          (context, state) => NoTransitionPage(child: const ProfileScreen()),
    ),
  ],
);
