import 'dart:developer';

import 'package:job_search_app/core/api/dio_client.dart';
import 'package:job_search_app/core/api/end_points.dart';
import 'package:job_search_app/features/auth/models/login_request_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr build() {
    return null;
  }

  Future login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    final response = await ref.read(dioClientProvider.notifier).postRequest(
      EndPoints.login,
      data: LoginRequestBody(
        email: email,
        password: password,
      ).toJson(),
    );
  }
}
