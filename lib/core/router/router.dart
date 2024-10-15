import 'package:go_router/go_router.dart';
import 'package:job_search_app/features/auth/pages/forgot_password_page.dart';
import 'package:job_search_app/features/auth/pages/login_page.dart';
import 'package:job_search_app/features/auth/pages/register_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/${RegisterPage.route}',
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
  ],
);
