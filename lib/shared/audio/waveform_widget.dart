import 'package:flutter/material.dart';

class WaveformWidget extends StatelessWidget {
  final List<double> samples;

  const WaveformWidget({super.key, required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 80,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: samples.map((value) {
          final normalized = value.clamp(0.05, 1.0);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),

              child: Container(
                height: normalized * 70,

                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,

                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
