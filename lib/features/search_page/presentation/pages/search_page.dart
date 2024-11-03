import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  static const String route = 'search';

  @override
  Widget build(BuildContext context, ref) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text('Search'),
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.blue,
            );
          },
        ),
      ],
    );
  }
}
