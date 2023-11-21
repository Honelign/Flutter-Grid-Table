import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerWithSeek extends StatefulWidget {
  const YouTubePlayerWithSeek({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _YouTubePlayerWithSeekState createState() => _YouTubePlayerWithSeekState();
}

class _YouTubePlayerWithSeekState extends State<YouTubePlayerWithSeek> {
  late YoutubePlayerController _controller;
  final String _videoId = 'CmC7giRPuyw'; // Replace with your desired video ID
  double _seekTime = 0.0; // Initial seek time

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        YoutubePlayer(controller: _controller),
        const SizedBox(height: 20.0),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Enter seek time (seconds)',
            ),
            onChanged: (value) {
              setState(() {
                _seekTime = double.tryParse(value) ?? 0.0;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _controller.seekTo(Duration(seconds: _seekTime.toInt()));
            // _controller.seekTo(_seekTime as Duration);
          },
          child: const Text('Seek'),
        ),
      ]),
    );
  }
}
