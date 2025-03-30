import 'package:go_router/go_router.dart';
import 'package:pooja_cart/features/domain/entities/order_items/order_items.dart';
import 'package:pooja_cart/features/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:pooja_cart/features/presentation/screens/home/home_screen.dart';
import 'package:pooja_cart/features/presentation/screens/order_summary/order_summary_screen.dart';
import 'package:pooja_cart/features/presentation/screens/profile/profile_screen.dart';

import 'features/presentation/common_widgets/app_scaffold.dart';
import 'features/presentation/screens/confirm_order/confirm_order_screen.dart';
import 'features/presentation/screens/contact/contact_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder:
              (context, state) => NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const ContactPage()),
        ),
        GoRoute(
          path: '/dashboard',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const DashboardScreen()),
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
              (context, state) =>
                  NoTransitionPage(child: const ProfileScreen()),
        ),
        GoRoute(
          path: '/confirm_order',
          pageBuilder: (context, state) {
            final orderItems = state.extra as List<OrderItems>? ?? [];
            return NoTransitionPage(
              child: ConfirmOrderScreen(orderItems: orderItems),
            );
          },
        ),
      ],
    ),
  ],
);
