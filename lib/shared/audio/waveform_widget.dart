import 'package:flutter/material.dart';
// import '../audio/waveform_controller.dart';
import '../audio/audio_editor_controller.dart';

class WaveformWidget extends StatefulWidget {
  // final List<double> samples;
  // final int trimStart;
  // final int trimEnd;
  // final double? playhead;
  // final ValueChanged<int>? onTrimStartChanged;
  // final ValueChanged<int>? onTrimEndChanged;
  // final VoidCallback? onPlay;
  // final WaveformController? controller;
  final AudioEditorController controller;

  const WaveformWidget({
    super.key,
    // required this.samples,
    // required this.trimStart,
    // required this.trimEnd,
    // this.playhead,
    // this.onTrimStartChanged,
    // this.onTrimEndChanged,
    // this.onPlay,
    required this.controller,
  });

  @override
  State<WaveformWidget> createState() {
    return _WaveformWidgetState();
  }
}

class _WaveformWidgetState extends State<WaveformWidget> {
  int localTrimStart = 0;
  int localTrimEnd = 0;

  double? localPlayhead;

  double? dragX;
  double? dragEndX;

  @override
  void initState() {
    super.initState();

    // if (widget.controller != null) {
    //   localTrimStart = widget.controller!.trimStart;

    //   localTrimEnd = widget.controller!.trimEnd;
    // } else {
    //   localTrimStart = widget.trimStart;

    //   localTrimEnd = widget.trimEnd;
    // }

    localTrimStart = widget.controller.trimStart;

    localTrimEnd = widget.controller.trimEnd;

    // localPlayhead = widget.controller?.playhead ?? widget.playhead;
    localPlayhead = widget.controller.playhead;

    widget.controller.addListener(_onControllerChanged);
  }

  // @override
  // void didUpdateWidget(covariant WaveformWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (oldWidget.trimStart != widget.trimStart ||
  //       oldWidget.trimEnd != widget.trimEnd) {
  //     localTrimStart = widget.trimStart;

  //     localTrimEnd = widget.trimEnd;
  //   }
  // }

  @override
  void didUpdateWidget(covariant WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onControllerChanged() {
    if (!mounted) return;

    setState(() {
      // localTrimStart = widget.controller?.trimStart ?? widget.trimStart;

      // localTrimEnd = widget.controller?.trimEnd ?? widget.trimEnd;
      localTrimStart = widget.controller.trimStart;
      localTrimEnd = widget.controller.trimEnd;

      // localPlayhead = widget.controller.playhead ?? widget.playhead;
      localPlayhead = widget.controller.playhead;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.samples.isEmpty) {
    //   return const SizedBox();
    // }

    if (widget.controller.samples.isEmpty) {
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        SizedBox(
          height: 90,

          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // final barWidth = width / widget.samples.length;
              final barWidth = width / widget.controller.samples.length;

              return Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: widget.controller.samples.asMap().entries.map((
                        entry,
                      ) {
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

                  /// Left mask
                  Positioned(
                    left: 0,

                    top: 0,

                    bottom: 0,

                    width: localTrimStart * barWidth,

                    child: IgnorePointer(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ),

                  /// Right mask
                  Positioned(
                    right: 0,

                    top: 0,

                    bottom: 0,

                    width:
                        // (widget.samples.length - 1 - localTrimEnd) * barWidth,
                        (widget.controller.samples.length - 1 - localTrimEnd) *
                        barWidth,

                    child: IgnorePointer(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ),

                  /// START HANDLE
                  Positioned(
                    left: localTrimStart * barWidth - 9,

                    top: 0,

                    bottom: 0,

                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,

                      onHorizontalDragUpdate: (details) {
                        dragX ??= localTrimStart * barWidth;

                        dragX = dragX! + details.delta.dx;

                        int index = (dragX! / barWidth).floor();

                        index = index.clamp(0, localTrimEnd - 1);

                        // setState(() {
                        //   localTrimStart = index;
                        // });
                        setState(() {
                          localTrimStart = index;

                          widget.controller.setTrimStart(localTrimStart);
                        });
                      },

                      // onHorizontalDragEnd: (_) {
                      //   widget.onTrimStartChanged?.call(localTrimStart);
                      // },
                      child: Container(
                        width: 50,

                        color: Colors.transparent,

                        child: Column(
                          children: [
                            Container(
                              width: 18,

                              height: 18,

                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,

                                shape: BoxShape.circle,
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 2,

                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// END HANDLE
                  Positioned(
                    left: localTrimEnd * barWidth - 9,

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

                          // widget.samples.length - 1,
                          widget.controller.samples.length - 1,
                        );

                        // setState(() {
                        //   localTrimEnd = index;
                        // });
                        setState(() {
                          localTrimEnd = index;

                          widget.controller.setTrimEnd(localTrimEnd);
                        });
                      },

                      // onHorizontalDragEnd: (_) {
                      //   widget.onTrimEndChanged?.call(localTrimEnd);
                      // },
                      child: Container(
                        width: 50,

                        color: Colors.transparent,

                        child: Column(
                          children: [
                            Container(
                              width: 18,

                              height: 18,

                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiary,

                                shape: BoxShape.circle,
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Container(
                                  width: 2,

                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (localPlayhead != null)
                    Positioned(
                      left: localPlayhead! * barWidth,

                      top: 0,

                      bottom: 0,

                      child: IgnorePointer(
                        child: Container(width: 2, color: Colors.white),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "$localTrimStart / $localTrimEnd",

          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),

        IconButton(
          // onPressed: widget.onPlay,
          onPressed: widget.controller.toggle,

          icon: Icon(
            widget.controller.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    );
  }
}
