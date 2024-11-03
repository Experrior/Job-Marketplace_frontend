import 'dart:async';

import 'package:job_search_app/features/home/data/repositories/jobs_repository.dart';

import '../../../../models/job.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_jobs_controller.g.dart';

@riverpod
class GetJobsController extends _$GetJobsController {
  @override
  FutureOr<List<Job>?> build() {
    return null;
  }

  Future<void> getJobs() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.watch(jobsRepositoryProvider).getJobs();
      return response;
    });
  }
}
