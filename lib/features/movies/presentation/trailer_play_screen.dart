import 'package:demo_app/core/utils/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPlayerScreen extends StatefulWidget {
  final String movieId;

  const TrailerPlayerScreen({super.key, required this.movieId});

  @override
  State<TrailerPlayerScreen> createState() => _TrailerPlayerScreenState();
}

class _TrailerPlayerScreenState extends State<TrailerPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _forceLandscape();
    _controller = YoutubePlayerController(
      initialVideoId: widget.movieId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(_listener);
  }

  void _forceLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _listener() {
    if (mounted && _controller.value.isReady && !_isReady) {
      setState(() {
        _isReady = true;
      });
    }
    if (_controller.value.playerState == PlayerState.ended) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next screen.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _restoreOrientation();
    super.dispose();
  }

  void _restoreOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        _forceLandscape();
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28.0),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        onReady: () {
          _isReady = true;
        },
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              player,
              if (!_isReady)
                const AppLoadingIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
