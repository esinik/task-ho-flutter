import 'package:go_router/go_router.dart';
import 'features/tasks/task_list_screen.dart';
import 'features/fees/fees_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/tasks',
  routes: [
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/fees',
      builder: (context, state) => const FeesScreen(),
    ),
  ],
);
