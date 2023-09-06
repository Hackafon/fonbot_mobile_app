import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fonbot_mobile_app/camera/presentation/widget/Camera.dart';
import 'package:roslibdart/core/core.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late Ros ros;
  String message = "";

  @override
  void initState() {
    super.initState();
    ros = Ros(url: "ws://192.168.0.18:9090");
  }

  void initConnection() async {
    ros.connect();
  }

  Future<void> subscribeHahdler(Map<String, dynamic> msg) async {
    String msgRecieved = json.encode(msg);
    print("MSG: $msgRecieved");
  }


  // Future<void> _subscribeForTopic(Topic topic) async {
  //   topic.subscribe((message) {
  //     print("${message}");
  //     final completer = Completer<void>();
  //     completer.complete();
  //     return completer.future;
  //   });
  // }

  void destoryConnection() async {
    await ros.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: const Text("Dashboard"),
        ),
        body: StreamBuilder<Object>(
          stream: ros.statusStream,
          builder: (context, snapshot) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text("Connect to robot: "),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ActionChip(
                      label: Text(snapshot.data == Status.connected
                          ? 'DISCONNECT'
                          : 'CONNECT'),
                      backgroundColor: snapshot.data == Status.connected
                          ? Colors.green[300]
                          : Colors.grey[300],
                      onPressed: () {
                        if (snapshot.data != Status.connected) {
                          initConnection();
                        } else {
                          destoryConnection();
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 500,
                    decoration: const BoxDecoration(
                        borderRadius:  BorderRadius.all(Radius.circular(40)),
                        color: Color.fromRGBO(120, 188, 216, 0.26)
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Camera"
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                const MaterialStatePropertyAll<Color>(Colors.lightBlueAccent),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                )),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Camera(ros: ros))),
                            child: const Text(
                                "Camera",
                                style: TextStyle(
                                  color: Colors.black
                                ),
                            )
                        )
                      ],
                    ),
                  ),
                  // StreamBuilder(
                  //   stream: ultrasonicFrontTopic.subscription,
                  //   builder: (context2, snapshot2) {
                  //     if (snapshot2.hasData) {
                  //       return Text('${snapshot2.data?['msg']}');
                  //     } else {
                  //       return const Text("");
                  //     }
                  //   },
                  // ),
                ],
              ),
            );
          },
        ));
  }
}
