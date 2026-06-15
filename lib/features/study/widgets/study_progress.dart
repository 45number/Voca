import 'package:flutter/material.dart';

class StudyProgress extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const StudyProgress({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: totalCount == 0 ? 0 : (currentIndex + 1) / totalCount,
    );
  }
}
