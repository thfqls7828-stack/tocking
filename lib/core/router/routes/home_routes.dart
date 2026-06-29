import 'package:go_router/go_router.dart';

import '../../../view/home_screen/home_screen.dart';
import '../route_names.dart';
import '../route_paths.dart';

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: RoutePaths.home,
    name: RouteNames.home,
    builder: (context, state) => const HomeScreen(),
  ),
];
