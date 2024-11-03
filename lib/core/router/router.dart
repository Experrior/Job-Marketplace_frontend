import 'package:go_router/go_router.dart';
import 'package:job_search_app/features/auth/pages/forgot_password_page.dart';
import 'package:job_search_app/features/auth/pages/login_page.dart';
import 'package:job_search_app/features/auth/pages/register_page.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../components/skeleton.dart';

final GoRouter router = GoRouter(
  initialLocation: '/${HomePage.route}',
  routes: [
    GoRoute(
      path: '/${RegisterPage.route}',
      name: RegisterPage.route,
      builder: (context, state) => RegisterPage(
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/${LoginPage.route}',
      name: LoginPage.route,
      builder: (context, state) => LoginPage(
        key: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/${ForgotPasswordPage.route}',
      name: ForgotPasswordPage.route,
      builder: (context, state) => ForgotPasswordPage(
        key: state.pageKey,
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        /// Skeleton for MacosWindow
        return Skeleton(
          key: state.pageKey,
          child: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${HomePage.route}',
              name: HomePage.route,
              builder: (context, state) => HomePage(
                key: state.pageKey,
              ),
            ),
          ],

        )
      ],
    )
  ],
);
