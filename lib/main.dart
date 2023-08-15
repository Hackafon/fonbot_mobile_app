import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roslibdart/core/core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Rosbridge communication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Ros ros;
  late Topic ultraconic_front_topic;
  String message = "";

  @override
  void initState() {
    super.initState();
    ros = Ros(url: "ws://your_wsl_address:9090");
    ultraconic_front_topic = Topic(
      ros: ros,
      name: "ultrasonic_front_driver",
      type: "std_msgs/Float32",
      reconnectOnClose: true
    );
  }

  void initConnection() async {
    ros.connect();
    await ultraconic_front_topic.subscribe(subscribeHahdler);
  }

  Future<void> subscribeHahdler(Map<String, dynamic> msg) async{
    String msgRecieved = json.encode(msg);
    print("MSG: $msgRecieved");
  }
  //
  // Future<void> _subscribeForTopic(Topic topic) async {
  //   topic.subscribe((message) {
  //     print("${message}");
  //     final completer = Completer<void>();
  //     completer.complete();
  //     return completer.future;
  //   });
  // }

  void destoryConnection() async {
    await ultraconic_front_topic.unsubscribe();
    await ros.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: StreamBuilder<Object>(
          stream: ros.statusStream,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionChip(
                    label: Text(snapshot.data == Status.connected
                        ? 'DISCONNECT'
                        : 'CONNECT'),
                    backgroundColor: snapshot.data == Status.connected
                        ? Colors.green[300]
                        : Colors.grey[300],
                    onPressed: () {
                      print(snapshot.data);
                      if (snapshot.data != Status.connected) {
                        this.initConnection();
                      } else {
                        this.destoryConnection();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: ultraconic_front_topic.subscription,
                    builder: (context2, snapshot2) {
                      if (snapshot2.hasData) {
                        print(snapshot2.data);
                        return Text('${snapshot2.data?['msg']}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}
