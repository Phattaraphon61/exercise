import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideosList extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const VideosList(
      {Key key, @required this.videoPlayerController, this.looping})
      : super(key: key);

  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  ChewieController videosController;

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
          
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    videosController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      looping: widget.looping,
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

  Widget progressBar() {
    return CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: videosController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    // widget.videoPlayerController.dispose();
    videosController.dispose();
  }
}
