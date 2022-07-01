import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'model/user.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List<User> users=getUsers();
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();

    usersFuture = getUsers(context);
  }

  static Future<List<User>> getUsers(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('lib/assets/dataset.json');
    // const data=[
    //   {
    //     "id": 1,
    //     "title": "Class 1",
    //     "videoUrl": "https://tech-assignments.yellowclass.com/1213_shipra_mam_7_papercrumpling_ice_cream/hls_session/session_video.m3u8",
    //     "coverPicture": "https://picsum.photos/800/450"
    //   },
    //   {
    //     "id": 2,
    //     "title": "Class 2",
    //     "videoUrl": "https://tech-assignments.yellowclass.com/1215_shipra_mam_8_papercruumpling_birthday_cap_1/hls_session/session_video.m3u8",
    //     "coverPicture": "https://picsum.photos/800/450"
    //   }
    // ];
    final body = json.decode(data);
    return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xff885566),
          title: const Text('Youtube'),
          centerTitle: true,
        ),
        body: Center(
            // child: buildUsers(users)
            child: FutureBuilder<List<User>>(
          future: usersFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return buildUsers(users);
            } else {
              return const Text('no videos available');
            }
          },
        )),
      ),
    );
  }

  Widget buildUsers(List<User> users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          // return Card(
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       radius: 28,
          //       backgroundImage: NetworkImage(user.coverPicture),
          //     ),
          //     title: Text(user.title),
          //   ),
          // );

          return Card(
              child: Column(children: <Widget>[
            Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(user.coverPicture),
                ),
                title: Text(user.title),
              ),
              Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    videoply(vrl: user.videoUrl),
                  ]),
            ]),
          ]));
        },
      );

// @override
// Widget build(BuildContext context) => Scaffold(
//   appBar: AppBar(
//       title: const Text('Youtube'),
//       centerTitle: true,
//   ),
// );

}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   List<User> users=getUsers();
//
//   static List<User> getUsers(){
//   const data=[
//   {
//   "id": 1,
//   "title": "Class 1",
//   "videoUrl": "https://tech-assignments.yellowclass.com/1213_shipra_mam_7_papercrumpling_ice_cream/hls_session/session_video.m3u8",
//   "coverPicture": "https://picsum.photos/800/450"
//   },
//   {
//   "id": 2,
//   "title": "Class 2",
//   "videoUrl": "https://tech-assignments.yellowclass.com/1215_shipra_mam_8_papercruumpling_birthday_cap_1/hls_session/session_video.m3u8",
//   "coverPicture": "https://picsum.photos/800/450"
//   }
//   ];
//   return data.map<User>(User.fromJson).toList();
// }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.red
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           // backgroundColor: const Color(0xff885566),
//           title: const Text('Youtube'),
//         ),
//       ),
//     );
//   }
// }

class videoply extends StatefulWidget {
  final String vrl;

  const videoply({Key? key, required this.vrl}) : super(key: key);

  @override
  State<videoply> createState() => _videoplyState(vrl);
}

class _videoplyState extends State<videoply> {
  // late String vurl;
  late VideoPlayerController _controller;
  late Uri uri;

  _videoplyState(String s) {
    uri = Uri.parse(s);
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.contentUri(uri);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
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
            padding: const EdgeInsets.only(top: 20.0),
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
                  // _ControlsOverlay(controller: _controller),
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
