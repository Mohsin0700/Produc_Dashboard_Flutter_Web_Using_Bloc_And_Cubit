import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/product/presentation/pages/products_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String dashboard = '/';
  static const String products = '/products';
  static const String productDetails = '/products/:id';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: dashboard,
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: products,
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: productDetails,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailsPage(productId: int.parse(id));
            },
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
