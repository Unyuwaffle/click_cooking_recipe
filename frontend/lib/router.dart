import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/result_screen.dart';

// Create a GoRouter object
final GoRouter router = GoRouter(

  // The app's starting (initial) path
  initialLocation: '/home',

  // Path definition
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
