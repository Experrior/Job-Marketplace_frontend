import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../models/job.dart';
import 'job_tile.dart';

class JobList extends StatelessWidget {
  const JobList({Key? key, required this.jobs}) : super(key: key);
  final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final Job job = jobs[index];
        return JobTile(job: job);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Gap(10);
      },
    );
  }
}
