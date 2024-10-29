
import 'package:job_search_app/models/job.dart';

abstract interface class IJobsDatasource {

  Future<List<Job>> getJobs();
}