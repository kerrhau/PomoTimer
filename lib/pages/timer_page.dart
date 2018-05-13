import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomotimer/timer.dart';
import 'package:pomotimer/interval_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
  final IntervalData data;
  TimerPage(this.data);

  @override
  TimerPageState createState() {
    return new TimerPageState();
  }
}

class SoundStorage {
  SoundStorage({
    this.fileName,
  });

  String fileName;

  Future<String> get _tmpPath async {
    final tmpdir = await getTemporaryDirectory();
    return tmpdir.path;
  }

  Future<File> get _beepFile async {
    final path = await _tmpPath;
    return new File('$path/${fileName}');
  }

  Future<ByteData> get _beepAsset async {
    return await rootBundle.load('sounds/$fileName');
  }

  Future<File> writeToFile() async {
    final file = await _beepFile;
    final asset = await _beepAsset;

    return await file.writeAsBytes(asset.buffer.asUint8List());
  }
}

class TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  AnimationController controller;
  Icon icon = new Icon(Icons.pause);
  AudioPlayer audioplayer = new AudioPlayer();
  SoundStorage sprintBeep = new SoundStorage(fileName: "beep.wav")..writeToFile();
  SoundStorage cooldownBeep = new SoundStorage(fileName: "beep.wav")..writeToFile();
  
  bool sprint = true;

  ThemeData themeData = new ThemeData(
    canvasColor: Colors.blueGrey,
    iconTheme: new IconThemeData(
      color: Colors.white,
    ),
    accentColor: Colors.pinkAccent,
    brightness: Brightness.dark,
  );

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: widget.data.sprint),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          if (sprint) {
            sprintBeep._beepFile.then((File file) {
              final result = audioplayer.play(file.path, isLocal: true);
            });
          } else {
            cooldownBeep._beepFile.then((File file) {
              final result = audioplayer.play(file.path, isLocal: true);
            });
          }
        }
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          if (sprint) {
            controller.duration = new Duration(seconds: widget.data.sprint);
            controller.reverse(
                from: controller.value == 0.0 ? 1.0 : controller.value);
            sprint = false;
          } else {
            controller.duration = new Duration(seconds: widget.data.cooldown);
            controller.reverse(
                from: controller.value == 0.0 ? 1.0 : controller.value);
            sprint = true;
          }
        }
      });
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      //  appBar: new AppBar(title: new Text('Timer')),
      floatingActionButton: new FloatingActionButton(
          child: icon,
          onPressed: () {
            if (controller.isAnimating) {
              setState(() {
                icon = new Icon(Icons.play_arrow);
              });
              controller.stop();
            } else {
              setState(() {
                icon = new Icon(Icons.pause);
              });
              controller.reverse(
                  from: controller.value == 0.0 ? 1.0 : controller.value);
            }
          }),
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topRight,
            end: new Alignment(0.5, 1.0),
            colors: [const Color(0xFFAD5389), const Color(0xFF3C1053)],
          ),
        ),
        padding: const EdgeInsets.all(0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(20.0),
              child: new Align(
                alignment: FractionalOffset.center,
                child: new AspectRatio(
                  aspectRatio: 1.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new Opacity(
                          opacity: 0.5,
                          child: new AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return new CustomPaint(
                                painter: new TimerPainter(
                                  animation: controller,
                                  timerColor:
                                      const Color(0XFF333333).withOpacity(1.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      new Align(
                        alignment: FractionalOffset.center,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new AnimatedBuilder(
                              animation: controller,
                              builder: (BuildContext context, Widget child) {
                                return new Text(timerString,
                                    style: new TextStyle(
                                        fontSize: 80.0, color: Colors.white));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
