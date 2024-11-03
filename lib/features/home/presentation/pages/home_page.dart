import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/get_jobs_controller.dart';
import 'package:macos_ui/macos_ui.dart';


class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static const String route = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      Future.microtask(() => ref.read(getJobsControllerProvider.notifier).getJobs());
      return null;
    }, []);


    final jobs = ref.watch(getJobsControllerProvider);

    final Widget body = jobs.when(
      data: (data) {
        return Text(data.toString());
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );

    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Job Search App'),
      ),
    );
  }
}
