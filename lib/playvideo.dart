import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:exercise/history.dart';
import 'package:exercise/loading.dart';
import 'package:exercise/main.dart';
import 'package:exercise/nogication.dart';
import 'package:exercise/videos_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class Playvideo extends StatefulWidget {
  @override
  _PlayvideoState createState() => _PlayvideoState();
}

class _PlayvideoState extends State<Playvideo> {
  String name;
  String email;
  String ids;
  String tokens;

  ChewieController videosController;
  bool startedPlaying = false;
  Time timeee;

  @override
  void initState() {
    super.initState();
    videosController = ChewieController(
      videoPlayerController: VideoPlayerController.asset(
        'assets/video.mp4',
      ),
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(child: progressBar());
      },
    );
    videosController.videoPlayerController.addListener(() {
      if (!videosController.videoPlayerController.value.isPlaying) {
        print(videosController.videoPlayerController.value.position.inSeconds);
        if (videosController.videoPlayerController.value.position.inSeconds ==
            271) {
          print('555');
          videosController.exitFullScreen();
          _showMyDialog();
        }
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการบันทึกวันและเวลาหรือไม่'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () async {
                // var now = new DateTime.now();
                // Map<String, dynamic> decodedToken = JwtDecoder.decode(tokens);
                // String url = 'https://infinite-caverns-30215.herokuapp.com/date';
                // String json =
                //     '{"userid": "${decodedToken['id']}" ,"date": "${now.day}-${now.month}-${now.year + 543}","time":"${now.hour}:${now.minute}"}';
                // var response = await http.post(url, body: json);
                // var uu = jsonDecode(response.body);
                // print(uu['status']);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () async {
                var now = new DateTime.now();
                Map<String, dynamic> decodedToken = JwtDecoder.decode(tokens);
                String url =
                    'https://infinite-caverns-30215.herokuapp.com/date';
                String json =
                    '{"userid": "${decodedToken['id']}" ,"date": "${now.day}-${now.month}-${now.year + 543}","time":"${now.hour}:${now.minute}"}';
                var response = await http.post(url, body: json);
                var uu = jsonDecode(response.body);
                print(uu['status']);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> checktoken() async {
    if (tokens == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        tokens = token;
        email = decodedToken['email'];
        name = decodedToken['name'];
        ids = decodedToken['id'];
        return true;
      });
    }
    return true;
  }

  Widget progressBar() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    // widget.videoPlayerController.dispose();
    videosController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: checktoken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (tokens != null) {
            return Scaffold(
              appBar: AppBar(title: Text("วีดีโอออกกำลังกาย")),
            body: Stack(children: <Widget>[
          ListView(
            children: <Widget>[
              VideosList(
                videoPlayerController: VideoPlayerController.asset(
                  'assets/video.mp4',
                ),
                looping: false,
              ),
            ],
          ),
        ]),
              drawer: Container(
                width: width * 0.6,
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: Image.asset(
                                'assets/logo.png',
                              ),
                            ),
                            Text('ชื่อ : $name'),
                            Text('อีเมล์ : $email')
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'ตั้งค่า',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notication()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'สถิติ',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'ออกจากระบบ',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Loading(),
            );
          }
        });
  }
}

class _ButterFlyAssetVideoInList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _ExampleCard(title: "Item a"),
        _ExampleCard(title: "Item b"),
        _ExampleCard(title: "Item c"),
        _ExampleCard(title: "Item d"),
        _ExampleCard(title: "Item e"),
        _ExampleCard(title: "Item f"),
        _ExampleCard(title: "Item g"),
        Card(
            child: Column(children: <Widget>[
          Column(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.cake),
                title: Text("Video video"),
              ),
              Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    _ButterFlyAssetVideo(),
                    Image.asset('assets/flutter-mark-square-64.png'),
                  ]),
            ],
          ),
        ])),
        _ExampleCard(title: "Item h"),
        _ExampleCard(title: "Item i"),
        _ExampleCard(title: "Item j"),
        _ExampleCard(title: "Item k"),
        _ExampleCard(title: "Item l"),
      ],
    );
  }
}

/// A filler card to show the video in a list of scrolling contents.
class _ExampleCard extends StatelessWidget {
  const _ExampleCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              FlatButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(false);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10),
          ),
          const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;
  Time timeee;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/video.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        if (_videoPlayerController.value.position.inSeconds == 271) {
          _showMyDialog();
        }
        // Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการบันทึกวันและเวลาหรือไม่'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notication()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      elevation: 0,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: FutureBuilder<bool>(
            future: started(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_videoPlayerController),
                      ClosedCaption(
                          text: _videoPlayerController.value.caption.text),
                      _ControlsOverlay(controller: _videoPlayerController),
                      VideoProgressIndicator(_videoPlayerController,
                          allowScrubbing: true),
                    ],
                  ),
                );
              } else {
                return const Text('waiting for video to load');
              }
            },
          ),
        ),
      ]),
    );

    // return SingleChildScrollView(
    //   child: Column(

    //     children: <Widget>[
    //         SizedBox(
    //             height: height * 0.1,
    //           ),
    //       Container(padding: const EdgeInsets.only(top: 20.0)),
    //       const Text('วีดีโอออกกำลังกาย'),
    //       Container(

    //         padding: const EdgeInsets.only(top: 15),
    //         child: AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: Stack(
    //             alignment: Alignment.bottomCenter,
    //             children: <Widget>[
    //               VideoPlayer(_controller),
    //               ClosedCaption(text: _controller.value.caption.text),
    //               _ControlsOverlay(controller: _controller),
    //               VideoProgressIndicator(_controller, allowScrubbing: true),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
