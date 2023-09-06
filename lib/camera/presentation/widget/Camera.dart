import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fonbot_mobile_app/shared/presentation/BackBar.dart';
import 'package:roslibdart/core/core.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.ros});

  final Ros ros;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  late Topic cameraTopic;

  @override
  void initState() {
    super.initState();
    cameraTopic = Topic(
        ros: widget.ros,
        name: "camera_driver",
        type: "sensor_msgs/msg/Image",
        reconnectOnClose: true
    );
    initConnection();
  }

  void initConnection() async {
    await cameraTopic.subscribe(subscribeHahdler);
  }

  Future<void> subscribeHahdler(Map<String, dynamic> msg) async {
    String msgRecieved = json.encode(msg);
    print("MSG: $msgRecieved");
  }

  void destoryConnection() async {
    await cameraTopic.unsubscribe();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackBar(
        onPressed: ()  {
          destoryConnection();
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Camera"),
            StreamBuilder(
              stream: cameraTopic.subscription,
              builder: (context2, snapshot2) {
                if (snapshot2.hasData) {
                  return Text('${snapshot2.data?['msg']}');
                } else {
                  return const Text("");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
