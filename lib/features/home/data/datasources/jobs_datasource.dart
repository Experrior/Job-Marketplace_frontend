
import 'package:job_search_app/models/job.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'jobs_mock_datasource.dart';

part 'jobs_datasource.g.dart';

@riverpod
IJobsDatasource jobsDatasource(JobsDatasourceRef ref) =>
    JobsMockDatasource();

abstract interface class IJobsDatasource {

  Future<List<Job>> getJobs();
}