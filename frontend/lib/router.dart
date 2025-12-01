import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/result_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'data/models/recipe_model.dart';

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
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        // 화면 이동 시 넘겨받은 Recipe 객체를 꺼냅니다.
        final recipe = state.extra as Recipe;
        return RecipeDetailScreen(recipe: recipe);
      },
    ),
  ],
);
