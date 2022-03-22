import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouse_gesture_detector_demo/workspace_controls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mouse Gesture Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Offset _position = Offset.zero;
  double _angle = 0.0;
  double _zoom = 14.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WorkspaceControls.orbit(
        onPan: (offset) {
          // print("pan: " + offset.toString());
          setState(() {
            _position += offset * 0.1;
          });
        },
        onRotate: (offset) {
          // print("rotate: " + offset.toString());
          setState(() {
            print(offset);
            _angle += (offset.dy * 0.1);
          });
        },
        onZoom: (offset) {
          // print("zoom: " + offset.toString());
          setState(() {
            _zoom += (offset.dy * 0.1);
          });
        },
        child: Scaffold(
          body: WorkspaceControls.orbit(
            onPan: (offset) {
              // print("pan: " + offset.toString());
              setState(() {
                _position += offset;
              });
            },
            onRotate: (offset) {
              // print("rotate: " + offset.toString());
              setState(() {
                print(offset);
                _angle += (offset.dy * 0.1);
              });
            },
            onZoom: (offset) {
              // print("zoom: " + offset.toString());
              setState(() {
                _zoom += (offset.dy * 0.1);
              });
            },
            child:Stack(
              children: [
                Positioned(
                  left: _position.dx,
                  top: _position.dy,
                  child: Transform.rotate(
                    angle: _angle,
                    child: Text(
                      "Lorem ipsum",
                      style: TextStyle(
                        fontSize: _zoom,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
