import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/get_jobs_controller.dart';

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
    return Scaffold(
      body: jobs.when(
        data: (data) {
          return Text(data.toString());
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
