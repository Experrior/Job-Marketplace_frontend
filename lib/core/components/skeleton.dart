import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:job_search_app/core/router/router.dart';
import 'package:job_search_app/features/home/presentation/pages/home_page.dart';

import 'package:macos_ui/macos_ui.dart';

import '../../features/search_page/presentation/pages/search_page.dart';

class Skeleton extends HookConsumerWidget {
  const Skeleton({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState(0);

    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: pageIndex.value,
            scrollController: scrollController,
            itemSize: SidebarItemSize.large,
            onChanged: (i) {
              pageIndex.value = i;
              switch (i) {
                case 0:
                  context.goNamed(HomePage.route);
                  break;
                case 1:
                  context.goNamed(SearchPage.route);
                  break;
              }
            },
            items: const [
              SidebarItem(
                label: Text('Home'),
              ),
              SidebarItem(
                label: Text('Search'),
              ),
            ],
          );
        },
      ),
      child: child,
    );
  }
}
