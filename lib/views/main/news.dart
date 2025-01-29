import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final PageController _pageController = PageController();
  final List<String> _videoUrls = [
    // 'https://youtube.com/shorts/81fpxtkvjKE?feature=shared',
    // 'https://youtube.com/shorts/Hzv9ahzWd6Y?si=HWDn4u7DJNpmpAc9',
    'https://youtube.com/shorts/6DJnN4S3xjs?si=dgBHF7o2yOS2rupO',
    'https://youtube.com/shorts/3a8rhg8sNws?si=NVYpso0AWIoUTQID',
    'https://youtube.com/shorts/RpcFlXgDKnI?si=Ycg3X9n3HVAStc2y',
    'https://youtube.com/shorts/2vJsLXpiuPI?si=4iokpdJNYcyfmcUw',
    'https://youtube.com/shorts/euEp6_-mFvs?si=vA_RNK0wQPwlnfms',
    'https://youtube.com/shorts/Ri3SvVS7lTg?si=iIpfmU-TLznXCOZu',
    'https://youtube.com/shorts/PyHVsxW0mek?si=3fPO3_P5znOgyGhp',
    'https://youtube.com/shorts/81fpxtkvjKE?feature=shared',
    'https://youtube.com/shorts/Hzv9ahzWd6Y?si=HWDn4u7DJNpmpAc9'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _videoUrls.length,
          itemBuilder: (context, index) {
            return ShortVideoWidget(
                videoUrl: _convertShortUrlToNormalUrl(_videoUrls[index]));
          },
        ),
      ),
    );
  }

  // Convert Shorts URL to regular YouTube URL
  String _convertShortUrlToNormalUrl(String shortsUrl) {
    final RegExp regex = RegExp(r"\/shorts\/([a-zA-Z0-9_-]+)");
    final match = regex.firstMatch(shortsUrl);
    if (match != null) {
      return 'https://youtube.com/watch?v=${match.group(1)}';
    }
    return shortsUrl; // Return original if it doesn't match
  }
}

class ShortVideoWidget extends StatefulWidget {
  final String videoUrl;

  const ShortVideoWidget({required this.videoUrl});

  @override
  _ShortVideoWidgetState createState() => _ShortVideoWidgetState();
}

class _ShortVideoWidgetState extends State<ShortVideoWidget> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false; // Track player initialization status

  @override
  void initState() {
    super.initState();
    // Extract video ID from the regular YouTube URL
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        mute: false,
      ),
    )..addListener(() {
        // Check if the player is ready to play
        if (_controller.value.isReady) {
          setState(() {
            isPlayerReady = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen video player
        true
            ? SizedBox.expand(
                child: YoutubePlayer(
                    controller: _controller, showVideoProgressIndicator: true),
              )
            : Center(
                child:
                    CircularProgressIndicator()), // Show a loading spinner while the video loads

        Positioned(
          right: 10,
          bottom: 10,
          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up, color: Colors.white),
                onPressed: () {
                  // Handle like
                },
              ),
              IconButton(
                icon: Icon(Icons.comment, color: Colors.white),
                onPressed: () {
                  // Handle comment
                },
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Handle share
                },
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          child: Text(
            "Video description goes here",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
