// import 'package:flutter/material.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';

// class AudioPreviewWidget extends StatefulWidget {
//   final String audioPath;

//   const AudioPreviewWidget({super.key, required this.audioPath});

//   @override
//   State<AudioPreviewWidget> createState() => _AudioPreviewWidgetState();
// }

// class _AudioPreviewWidgetState extends State<AudioPreviewWidget> {
//   late final PlayerController playerController;

//   bool isLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox();
//   }

//   @override
//   void initState() {
//     super.initState();

//     initializePlayer();
//   }

//   Future<void> initializePlayer() async {
//     playerController = PlayerController();

//     await playerController.preparePlayer(path: widget.audioPath);

//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       isLoaded = true;
//     });
//   }

//   @override
//   void dispose() {
//     playerController.dispose();

//     super.dispose();
//   }
// }
