import 'package:flutter/material.dart';

import 'bulk_import/bulk_import_tab.dart';
import 'word_editor.dart';

class AddWordPage extends StatelessWidget {
  final String folderId;

  const AddWordPage({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Words'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Single'),
              Tab(text: 'Bulk Import'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WordEditor(folderId: folderId),
            BulkImportTab(folderId: folderId),
          ],
        ),
      ),
    );
  }
}
