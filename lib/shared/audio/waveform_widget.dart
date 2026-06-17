import 'package:flutter/material.dart';

class WaveformWidget extends StatefulWidget {
  final List<double> samples;
  final int trimStart;
  final int trimEnd;
  final ValueChanged<int>? onTrimStartChanged;
  final ValueChanged<int>? onTrimEndChanged;

  const WaveformWidget({
    super.key,
    required this.samples,
    required this.trimStart,
    required this.trimEnd,
    this.onTrimStartChanged,
    this.onTrimEndChanged,
  });

  @override
  State<WaveformWidget> createState() {
    return _WaveformWidgetState();
  }
}

class _WaveformWidgetState extends State<WaveformWidget> {
  int localTrimStart = 0;
  int localTrimEnd = 0;

  double? dragX;
  double? dragEndX;

  @override
  void initState() {
    super.initState();

    localTrimStart = widget.trimStart;
    localTrimEnd = widget.trimEnd;
  }

  @override
  void didUpdateWidget(covariant WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trimStart != widget.trimStart ||
        oldWidget.trimEnd != widget.trimEnd) {
      localTrimStart = widget.trimStart;

      localTrimEnd = widget.trimEnd;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 90,

      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final barWidth = width / widget.samples.length;

          debugPrint("build left=${localTrimStart * barWidth}");

          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: widget.samples.asMap().entries.map((entry) {
                    final index = entry.key;

                    final value = entry.value;

                    final insideTrim =
                        index >= localTrimStart && index <= localTrimEnd;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),

                        child: Container(
                          height: value * 70,

                          decoration: BoxDecoration(
                            color: insideTrim
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,

                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Positioned(
                left: (dragX ?? localTrimStart * barWidth) - 9,

                top: 0,

                bottom: 0,

                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,

                  onHorizontalDragUpdate: (details) {
                    debugPrint("dx=${details.delta.dx}");
                    debugPrint("start=$localTrimStart");
                    dragX ??= localTrimStart * barWidth;

                    dragX = dragX! + details.delta.dx;

                    int index = (dragX! / barWidth).floor();

                    debugPrint("dragX=$dragX index=$index");

                    index = index.clamp(0, localTrimEnd - 1);

                    debugPrint("index=$index");

                    // setState(() {
                    //   localTrimStart = index;
                    // });
                    // setState(() {
                    //   localTrimStart = index;
                    // });
                    setState(() {
                      if (index >= localTrimEnd) {
                        return;
                      }

                      localTrimStart = index;
                    });
                  },

                  // onHorizontalDragEnd: (_) {
                  //   widget.onTrimStartChanged?.call(localTrimStart);
                  // },
                  onHorizontalDragEnd: (_) {
                    // dragX = null;

                    widget.onTrimStartChanged?.call(localTrimStart);
                  },
                  child: Container(
                    width: 50,

                    color: Colors.transparent,

                    child: Column(
                      children: [
                        Container(
                          width: 18,

                          height: 18,

                          decoration: const BoxDecoration(
                            color: Colors.green,

                            shape: BoxShape.circle,
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Container(width: 2, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // пока ручки не переносим
              Positioned(
                left: (dragEndX ?? localTrimEnd * barWidth) - 9,

                top: 0,

                bottom: 0,

                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,

                  onHorizontalDragUpdate: (details) {
                    dragEndX ??= localTrimEnd * barWidth;

                    dragEndX = dragEndX! + details.delta.dx;

                    int index = (dragEndX! / barWidth).floor();

                    index = index.clamp(
                      localTrimStart + 1,

                      widget.samples.length - 1,
                    );

                    // setState(() {
                    //   localTrimEnd = index;
                    // });
                    // setState(() {
                    //   localTrimEnd = index;
                    // });
                    setState(() {
                      if (index <= localTrimStart) {
                        return;
                      }

                      localTrimEnd = index;
                    });
                  },

                  // onHorizontalDragEnd: (_) {
                  //   widget.onTrimEndChanged?.call(localTrimEnd);
                  // },
                  onHorizontalDragEnd: (_) {
                    // dragEndX = null;

                    widget.onTrimEndChanged?.call(localTrimEnd);
                  },

                  child: Container(
                    width: 50,

                    color: Colors.transparent,

                    child: Column(
                      children: [
                        Container(
                          width: 18,

                          height: 18,

                          decoration: const BoxDecoration(
                            color: Colors.red,

                            shape: BoxShape.circle,
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Container(width: 2, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
