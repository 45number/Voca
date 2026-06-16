import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../folder_controller.dart';

class MoveFolderDialog extends StatefulWidget {
  final Folder folder;

  const MoveFolderDialog({super.key, required this.folder});

  static Future<String?> show({
    required BuildContext context,
    required Folder folder,
  }) {
    return showDialog<String?>(
      context: context,
      builder: (_) => MoveFolderDialog(folder: folder),
    );
  }

  @override
  State<MoveFolderDialog> createState() => _MoveFolderDialogState();
}

class _MoveFolderDialogState extends State<MoveFolderDialog> {
  final controller = FolderController();

  final expandedFolders = <String>{};

  List<Folder> folders = [];

  List<String> descendants = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    folders = await controller.getAllFolders();

    descendants = await controller.getDescendantFolderIds(widget.folder.id);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Move "${widget.folder.name}"'),
      content: SizedBox(
        width: 400,
        height: 400,
        child: folders.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('Root'),
                  ),

                  ...getChildFolders(
                    null,
                  ).map((folder) => buildFolderTree(folder, 0)),
                ],
              ),
      ),
    );
  }

  List<Folder> getChildFolders(String? parentId) {
    return folders.where((folder) => folder.parentId == parentId).toList();
  }

  Widget buildFolderTree(Folder folder, int level) {
    final children = getChildFolders(folder.id);

    final isExpanded = expandedFolders.contains(folder.id);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + level * 24),
          leading: children.isEmpty
              ? const SizedBox(width: 24)
              : IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isExpanded) {
                        expandedFolders.remove(folder.id);
                      } else {
                        expandedFolders.add(folder.id);
                      }
                    });
                  },
                ),
          title: Text(folder.name),
        ),

        if (isExpanded)
          ...children.map((child) => buildFolderTree(child, level + 1)),
      ],
    );
  }
}
