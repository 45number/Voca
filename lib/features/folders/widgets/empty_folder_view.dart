import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class EmptyFolderView
    extends StatelessWidget {
  final bool isRoot;

  const EmptyFolderView({
    super.key,
    required this.isRoot,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.folder_outlined,
            size: 72,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            isRoot
                ? 'No folders yet'
                : 'No folders or words yet',
            style:
                AppTypography.progress,
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Text(
            isRoot
                ? 'Create your first folder'
                : 'Add a folder or word',
          ),
        ],
      ),
    );
  }
}