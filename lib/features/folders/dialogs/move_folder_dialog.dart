import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../folder_controller.dart';

class MoveFolderDialog extends StatefulWidget {
  final Folder folder;

  const MoveFolderDialog({super.key, required this.folder});

  static Future<Object?> show({
    required BuildContext context,
    required Folder folder,
  }) {
    return showDialog<Object?>(
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

  String? selectedParentId;

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

    selectedParentId = widget.folder.parentId;

    final path = await controller.getFolderPath(widget.folder.id);

    for (final folder in path) {
      expandedFolders.add(folder.id);
    }

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
                  ListTile(
                    selected: selectedParentId == null,
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Root'),
                    onTap: () {
                      setState(() {
                        selectedParentId = null;
                      });
                    },
                  ),

                  ...getChildFolders(
                    null,
                  ).map((folder) => buildFolderTree(folder, 0)),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),

        FilledButton(
          onPressed: selectedParentId == widget.folder.parentId
              ? null
              : () {
                  Navigator.pop(context, selectedParentId);
                },
          child: const Text('Move'),
        ),
      ],
    );
  }

  List<Folder> getChildFolders(String? parentId) {
    return folders
        .where(
          (folder) =>
              folder.parentId == parentId &&
              folder.id != widget.folder.id &&
              // folder.id != widget.folder.parentId &&
              !descendants.contains(folder.id),
        )
        .toList();
  }

  Widget buildFolderTree(Folder folder, int level) {
    final children = getChildFolders(folder.id);

    final isExpanded = expandedFolders.contains(folder.id);

    return Column(
      children: [
        ListTile(
          selected: selectedParentId == folder.id,
          contentPadding: EdgeInsets.only(left: level * 20.0),
          leading: children.isEmpty
              ? const SizedBox(width: 40)
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
          onTap: () {
            setState(() {
              selectedParentId = folder.id;
            });
          },
        ),

        if (isExpanded)
          ...children.map((child) => buildFolderTree(child, level + 1)),
      ],
    );
  }
}
