import 'package:injectable/injectable.dart';
import 'package:job_search_app/core/error/failures.dart';
import 'package:job_search_app/features/home/data/datasources/jobs_datasource.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../models/job.dart';

part 'jobs_repository.g.dart';

@Riverpod(keepAlive: true)
JobsRepository jobsRepository(JobsRepositoryRef ref) =>
    JobsRepository(ref.watch(jobsDatasourceProvider));

class JobsRepository {
  final IJobsDatasource jobsDatasource;

  JobsRepository(this.jobsDatasource);

  Future<List<Job>> getJobs() async {
    List<Job> jobs = await jobsDatasource.getJobs();
    return jobs;
  }
}
