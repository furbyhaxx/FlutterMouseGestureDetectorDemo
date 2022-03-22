// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Mouse Gesture Demo',
//       theme: ThemeData.dark(),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool _hasFocus = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: WorkspaceControls(
//         pan: ControlGesture(button: kTertiaryButton, key: null, callback: (Offset offset){ print("pan, " + offset.toString());}),
//         rotate: ControlGesture(button: kTertiaryButton, key: null, callback: (Offset offset){ print("pan, " + offset.toString());}),
//         zoom: ControlGesture(button: kTertiaryButton, key: null, callback: (Offset offset){ print("pan, " + offset.toString());}),
//         child: Container(
//           color: Colors.grey,
//           child: Stack(
//             children: [
//               const Positioned.fill(
//                 child: Center(
//                   child: Text(
//                     "Make mouse gestures here..",
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Text("focus: " + _hasFocus.toString()),
//               ),
//             ],
//           ),
//         ),
//       ),
//       // body: KeyboardListener(
//       //   autofocus: true,
//       //   onKeyCallbacks: <LogicalKeyboardKey, KeyboardKeyCallback>{
//       //     LogicalKeyboardKey.controlLeft: (down, event) {
//       //       print("ctrl down = " + down.toString());
//       //     }
//       //   },
//       //   child: Listener(
//       //     onPointerDown: (event) {
//       //       print("down");
//       //     },
//       //     onPointerUp: (event) {
//       //       print("up");
//       //     },
//       //     onPointerMove: (event) {
//       //       // only gets called when a button is pressed while moving
//       //       if (event.buttons == kPrimaryButton) {
//       //         print("primary move");
//       //       } else if (event.buttons == kSecondaryButton) {
//       //         print("secondary move");
//       //       } else if (event.buttons == kTertiaryButton) {
//       //         print("tertiary move");
//       //       }
//       //     },
//       //     onPointerHover: (event) {
//       //       // gets called also when no button is pressed.
//       //       // print("hover");
//       //     },
//       //     onPointerCancel: (event) {
//       //       print("cancel");
//       //     },
//       //     child: Container(
//       //       color: Colors.grey,
//       //       child: Stack(
//       //         children: [
//       //           const Positioned.fill(
//       //             child: Center(
//       //               child: Text(
//       //                 "Make mouse gestures here..",
//       //                 style: TextStyle(
//       //                   fontSize: 30,
//       //                   fontWeight: FontWeight.bold,
//       //                 ),
//       //               ),
//       //             ),
//       //           ),
//       //           Positioned(
//       //             right: 0,
//       //             bottom: 0,
//       //             child: Text("focus: " + _hasFocus.toString()),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
//
//
//
// // typedef ControlGestureCallback = void Function(Offset offset);
// //
// // class ControlGesture {
// //   const ControlGesture({required this.pointer, this.key, required this.callback,});
// //
// //   final LogicalKeyboardKey? key;
// //   final int pointer;
// //
// //   final ControlGestureCallback callback;
// // }
// //
// // // class PanControlGesture extends ControlGesture {
// // //   const PanControlGesture({required pointer, key, required this.callback})
// // //       : super(pointer: pointer, key: key);
// // //
// // //   final ControlGestureCallback callback;
// // // }
// // //
// // // class RotateControlGesture extends ControlGesture {
// // //   const RotateControlGesture({required pointer, key, required this.callback})
// // //       : super(pointer: pointer, key: key);
// // //
// // //   final ControlGestureCallback callback;
// // // }
// // //
// // // const kMouseWheel = 999;
// // //
// // // class ZoomControlGesture extends ControlGesture {
// // //   const ZoomControlGesture({required pointer, key, required this.callback})
// // //       : super(pointer: pointer, key: key);
// // //
// // //   final ControlCallback callback;
// // // }
// //
// // class WorkspaceControls extends StatelessWidget {
// //   WorkspaceControls({
// //     required this.child,
// //     required this.pan,
// //     required this.rotate,
// //     required this.zoom,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   /// The child widget
// //   final Widget child;
// //
// //   final ControlGesture pan;
// //   final ControlGesture rotate;
// //   final ControlGesture zoom;
// //
// //   KeyPressState _panKeyState = KeyPressState.undefined;
// //   KeyPressState _rotateKeyState = KeyPressState.undefined;
// //   KeyPressState _zoomKeyState = KeyPressState.undefined;
// //
// //   Map<LogicalKeyboardKey, KeyboardKeyCallback>? _keyboardCallbacks;
// //
// //   Map<LogicalKeyboardKey, KeyboardKeyCallback> _buildKeyboardCallbackList() {
// //     Map<LogicalKeyboardKey, KeyboardKeyCallback> data = {};
// //     if(pan.key != null) {
// //       data[pan.key!] = (down, event) {
// //         _panKeyState = down ? KeyPressState.down : KeyPressState.up;
// //       };
// //     }
// //     if(rotate.key != null) {
// //       data[rotate.key!] = (down, event) {
// //         _rotateKeyState = down ? KeyPressState.down : KeyPressState.up;
// //       };
// //     }
// //     if(zoom.key != null) {
// //       data[zoom.key!] = (down, event) {
// //         _zoomKeyState = down ? KeyPressState.down : KeyPressState.up;
// //       };
// //     }
// //
// //     _keyboardCallbacks = data;
// //
// //     return data;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return KeyboardListener(
// //       autofocus: true,
// //       onKeyCallbacks: _keyboardCallbacks ?? _buildKeyboardCallbackList(),
// //       child: Listener(
// //         onPointerDown: (event) {
// //           // print("down");
// //         },
// //         onPointerUp: (event) {
// //           // print("up");
// //         },
// //         onPointerMove: (event) {
// //           // only gets called when a button is pressed while moving
// //
// //           if(pan.pointer == event.buttons && _panKeyState != KeyPressState.up) {
// //             // pan
// //             pan.callback(event.delta);
// //           } else if(rotate.pointer == event.buttons && _rotateKeyState != KeyPressState.up) {
// //             // rotate
// //             rotate.callback(event.delta);
// //           } else if(zoom.pointer == event.buttons && _zoomKeyState != KeyPressState.up) {
// //             // zoom
// //             zoom.callback(event.delta);
// //           } else {
// //
// //           }
// //
// //           // if (pan != null && event.buttons == pan!.pointer) {}
// //
// //           // if (event.buttons == kPrimaryButton) {
// //           //   print("primary move");
// //           // } else if (event.buttons == kSecondaryButton) {
// //           //   print("secondary move");
// //           // } else if (event.buttons == kTertiaryButton) {
// //           //   print("tertiary move");
// //           // }
// //         },
// //         onPointerHover: (event) {
// //           // gets called also when no button is pressed.
// //           // print("hover");
// //         },
// //         onPointerCancel: (event) {
// //           // print("cancel");
// //         },
// //         onPointerSignal: (PointerSignalEvent event) {
// //           if(zoom.pointer == kMouseWheel && _zoomKeyState != KeyPressState.up) {
// //             if (event is PointerScrollEvent) {
// //               // PointerScrollEvent e = event as PointerScrollEvent;
// //               zoom.callback(Offset(0, event.scrollDelta.dy));
// //             }
// //           }
// //           // if (event is PointerScrollEvent) {
// //           //   // print('x: ${event.position.dx}, y: ${event.position.dy}');
// //           //   // print('scroll delta: ${event.scrollDelta}');
// //           //   PointerScrollEvent e = event as PointerScrollEvent;
// //           //   _zoom(event.scrollDelta.dy);
// //           //   // Offset
// //           // }
// //           // if(tertiaryButtonDown) {
// //           //   print(event);
// //           // }
// //           // // if(event is PointerDownEvent) {
// //           // //   PointerDownEvent e = event as PointerDownEvent;
// //           // //   print(e);
// //           // // }
// //         },
// //         child: child,
// //       ),
// //     );
// //   }
// // }
