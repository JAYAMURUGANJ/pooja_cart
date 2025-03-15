import 'package:go_router/go_router.dart';
import 'package:pooja_cart/screens/cart_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: CartScreen()),
    ),
    // GoRoute(
    //   path: '/about',
    //   pageBuilder:
    //       (context, state) => NoTransitionPage(child: const AboutScreen()),
    // ),
    // GoRoute(
    //   path: '/services',
    //   pageBuilder:
    //       (context, state) => NoTransitionPage(child: const ServicesScreen()),
    // ),
    // GoRoute(
    //   path: '/projects',
    //   pageBuilder:
    //       (context, state) => NoTransitionPage(child: const ProjectsScreen()),
    // ),
    // GoRoute(
    //   path: '/contact',
    //   pageBuilder:
    //       (context, state) => NoTransitionPage(child: const ContactScreen()),
    // ),
  ],
);
