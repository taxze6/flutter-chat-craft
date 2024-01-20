import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_craft/res/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class ChatVoiceView extends StatefulWidget {
  // final int index;
  // final Stream<int>? clickStream;
  final bool isReceived;
  final String? soundPath;
  final String? soundUrl;
  final int? duration;

  const ChatVoiceView({
    Key? key,
    // required this.index,
    // required this.clickStream,
    required this.isReceived,
    this.soundPath,
    this.soundUrl,
    this.duration,
  }) : super(key: key);

  @override
  _ChatVoiceViewState createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView> {
  bool _isPlaying = false;
  bool _isExistSource = false;
  final _voicePlayer = AudioPlayer();
  StreamSubscription? _clickSubs;

  @override
  void initState() {
    _voicePlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          setState(() {
            if (_isPlaying) {
              _isPlaying = false;
              // _voicePlayer.stop();
            }
          });
          break;
      }
    });
    _initSource();
    // _clickSubs = widget.clickStream?.listen((i) {
    //   if (!mounted) return;
    //   print('click:$i    $_isExistSource');
    //   if (_isExistSource) {
    //     print('sound click:$i');
    //     if (_isClickedLocation(i)) {
    //       setState(() {
    //         if (_isPlaying) {
    //           print('sound stop:$i');
    //           _isPlaying = false;
    //           _voicePlayer.stop();
    //         } else {
    //           print('sound start:$i');
    //           _isPlaying = true;
    //           _voicePlayer.seek(Duration.zero);
    //           _voicePlayer.play();
    //         }
    //       });
    //     } else {
    //       if (_isPlaying) {
    //         setState(() {
    //           print('sound stop:$i');
    //           _isPlaying = false;
    //           _voicePlayer.stop();
    //         });
    //       }
    //     }
    //   }
    // });
    super.initState();
  }

  void _initSource() async {
    String? path = widget.soundPath;
    String? url = widget.soundUrl;
    if (widget.isReceived) {
      if (null != url && url.trim().isNotEmpty) {
        _isExistSource = true;
        _voicePlayer.setUrl(url);
      }
    } else {
      var _existFile = false;
      if (path != null && path.trim().isNotEmpty) {
        var file = File(path);
        _existFile = await file.exists();
      }
      if (_existFile) {
        _isExistSource = true;
        _voicePlayer.setFilePath(path!);
      } else if (null != url && url.trim().isNotEmpty) {
        _isExistSource = true;
        _voicePlayer.setUrl(url);
      }
    }
  }

  @override
  void dispose() {
    _voicePlayer.dispose();
    _clickSubs?.cancel();
    super.dispose();
  }

  // bool _isClickedLocation(i) => i == widget.index;

  Widget _buildVoiceAnimView() {
    String anim;
    String png;
    int turns;
    if (widget.isReceived) {
      anim = 'assets/anim/voice_black.json';
      png = ImagesRes.icVoiceBlack;
      turns = 0;
    } else {
      anim = 'assets/anim/voice_blue.json';
      png = ImagesRes.icVoiceBlue;
      turns = 90;
    }
    return Row(
      children: [
        Visibility(
          visible: !widget.isReceived,
          child: Text(
            '${widget.duration ?? 0}',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ),
        _isPlaying
            ? RotatedBox(
                quarterTurns: turns,
                child: Lottie.asset(
                  anim,
                  height: 19.h,
                  width: 18.w,
                ),
              )
            : Image.asset(
                png,
                height: 19.h,
                width: 18.w,
              ),
        Visibility(
          visible: widget.isReceived,
          child: Text(
            '${widget.duration ?? 0}``',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVoiceAnimView();
  }
}
