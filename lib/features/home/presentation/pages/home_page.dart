import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_search_app/core/components/scaffold_wrapper.dart';
import 'package:job_search_app/features/home/presentation/components/job_list.dart';

import '../../../../core/components/logo.dart';
import '../controllers/get_jobs_controller.dart';
import 'package:macos_ui/macos_ui.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static const String route = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(
          () => ref.read(getJobsControllerProvider.notifier).getJobs());
      return null;
    }, []);

    final jobs = ref.watch(getJobsControllerProvider);

    final Widget body = jobs.when(
      data: (jobs) {
        return JobList(jobs: jobs!);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );

    return MacosScaffold(
      toolBar: const ToolBar(
        leading: Center(
          widthFactor: 1,
          child: Logo(),
        ),
        title: Text('Job Search App'),
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return body;
          },
        ),
      ],
    );
  }
}
