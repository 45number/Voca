import 'package:flutter/material.dart';
import '../controllers/audio_editor_controller.dart';

class AudioEditorWidget extends StatefulWidget {
  final AudioEditorController controller;

  const AudioEditorWidget({super.key, required this.controller});

  @override
  State<AudioEditorWidget> createState() {
    return _AudioEditorWidgetState();
  }
}

class _AudioEditorWidgetState extends State<AudioEditorWidget> {
  int localTrimStart = 0;
  int localTrimEnd = 0;

  double? localPlayhead;

  double? dragX;
  double? dragEndX;

  @override
  void initState() {
    super.initState();

    localTrimStart = widget.controller.trimStart;
    localTrimEnd = widget.controller.trimEnd;
    localPlayhead = widget.controller.playhead;

    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AudioEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onControllerChanged() {
    if (!mounted) return;

    setState(() {
      localTrimStart = widget.controller.trimStart;
      localTrimEnd = widget.controller.trimEnd;

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

                        setState(() {
                          localTrimStart = index;

                          widget.controller.setTrimStart(localTrimStart);
                        });
                      },

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

                          widget.controller.samples.length - 1,
                        );

                        setState(() {
                          localTrimEnd = index;

                          widget.controller.setTrimEnd(localTrimEnd);
                        });
                      },
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

        // Text(
        //   "$localTrimStart / $localTrimEnd",

        //   style: Theme.of(context).textTheme.bodySmall,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(widget.controller.formatPosition(localTrimStart)),

            Text(widget.controller.formatPosition(localTrimEnd)),
          ],
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
