
# FONbot Mobile App

Flutter application for FONbot - robot assistant made at FON




## Prerequisites

For this project I use Windows 10 OS, but rosbridge_suite is only compatible with Ubuntu and I have installed Windows Subsystem for Linux (WSL) - Ubuntu.

Prerequisites:
- Installed ROS2 Humble and configured fonbot_ros package  (check [FONBot ROS](https://github.com/Hackafon/fonbot_ros#readme) for help) - install on both Windows and WSL
- Installed FONBot Unity project (check [FONBot simulation](https://github.com/Hackafon/fonbot_simulation#readme) for help) - install on Windows
- Installed and configured IDE for work in Flutter (IntelliJ IDEA is recommended) - install on Windows
## Install Rosbridge_suite

We use [roslibdart](https://pub.dev/packages/roslibdart) package for communication with ROS2. Roslibdart is a library for communicating to a ROS node over websockets with rosbridge_suite. Once you have ROS2 installed on WSL, clone the [repository](https://github.com/RobotWebTools/rosbridge_suite) in /src directory of your ROS2 workspace. Then build your project and when build has finished, source the package (make sure you are in root directory of your ROS2 workspace):
```bash
  colcon build --symlink-install
  source install/setup.bash
```
 When you source package, run next command for launch rosbridge server on port 9090 (default port for Rosbridge).
 ```bash
  ros2 launch rosbridge_server rosbridge_websocket_launch.xml
```


## Open Unity project

From your ROS2 terminal on Windows, type the following command:
 ```bash
  <path to unity installation folder\Unity.exe> -projectPath <project path>
```

## Flutter app

At the end, if you have installed in configured IDE for work in Flutter, clone this project on your Windows machine. Open project with IDE and you can run app on emulator or real device connected to your machine.

In order to connect your device to rosbridge over websockets you have to modify address in code. Change this line of code, your_wsl_address to real one: 
```dart
    ros = Ros(url: "ws://your_wsl_address:9090");

```
**NOTE:** You can check your address on WSL with:
```bash
  ifconfig
```