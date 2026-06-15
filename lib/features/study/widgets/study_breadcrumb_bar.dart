import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class StudyBreadcrumbBar extends StatelessWidget {
  final String path;

  final int currentIndex;

  final int totalCount;

  const StudyBreadcrumbBar({
    super.key,
    required this.path,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Current deck'),
                      content: SelectableText(path),
                    );
                  },
                );
              },
              child: Text(
                path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Text(
            '${currentIndex + 1}/$totalCount',
            style: AppTypography.bodySecondary,
          ),
        ],
      ),
    );
  }
}
