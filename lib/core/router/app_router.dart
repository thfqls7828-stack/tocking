import 'package:go_router/go_router.dart';

import 'route_paths.dart';
import 'routes/home_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: homeRoutes,
  );
}
