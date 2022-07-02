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
  late Future<List<User>> usersFuture;

  @override
  void initState() {
    super.initState();

    usersFuture = getUsers(context);
  }

  static Future<List<User>> getUsers(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('lib/assets/dataset.json');

    final body = json.decode(data);
    return body.map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Youtube'),
        ),
        body: Center(
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
        drawer: Drawer(
          child: ListView(
            children: const <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Shashank Maurya"),
                accountEmail: Text("shashankmaurya260101@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.brown,
                  child: Text("S", style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUsers(List<User> users) => ListView.builder(
    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];


      return Card(
          child: Column(children: <Widget>[
            Column(children: <Widget>[
              Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    videoply(vrl: user.videoUrl),
                  ]),
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(user.coverPicture),
                ),
                title: Text(user.title, style: const TextStyle(fontSize: 18)),
                contentPadding: const EdgeInsets.all(10),
              ),
            ]),
          ]));
    },
  );
}

class videoply extends StatefulWidget {
  final String vrl;

  const videoply({Key? key, required this.vrl}) : super(key: key);

  @override
  State<videoply> createState() => _videoplyState(vrl);
}

class _videoplyState extends State<videoply> {
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
            padding: const EdgeInsets.only(top: 10.0),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
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