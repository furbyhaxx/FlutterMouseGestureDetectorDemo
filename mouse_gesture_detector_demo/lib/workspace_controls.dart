import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'keyboard_listener.dart';

/// constant for the mousewheel button as pointer
const kMouseWheel = 999;

/// callback for [WorkspaceControls] actions
typedef ControlGestureCallback = void Function(Offset offset);

/// defines a gesture used by [WorkspaceControls]
class ControlGesture {
  const ControlGesture({
    required this.button,
    this.key,
    this.keySet = const {},
    required this.callback,
  });

  /// The single key of this [ControlGesture]
  final LogicalKeyboardKey? key;

  /// The keyset key of this [ControlGesture]
  final Set keySet;

  // static const LogicalKeySet shiftKeys = LogicalKeySet();

  /// The pointer button of this [ControlGesture]
  final int button;

  /// The callback of this [ControlGesture]
  final ControlGestureCallback callback;
}

enum ControlState {
  none,
  pan,
  dolly,
  zoom,
}

/// A widget that provides camera controls in a [Workspace]
/// [child] Widget (usually Scaffold)
/// [pan] is the [ControlGesture] object for pan gesture
/// [rotate] is the [ControlGesture] object for rotate gesture
/// [zoom] is the [ControlGesture] object for zoom gesture
class WorkspaceControls extends StatelessWidget {
  WorkspaceControls({
    required this.child,
    required this.pan,
    required this.rotate,
    required this.zoom,
    Key? key,
  }) : super(key: key);

  /// A predefined instance of [WorkspaceControls] to navigate in an orbit around the target
  /// Pan is done trought dragging with the tertiary button (mouse wheel and xxx on touchscreen)
  /// Rotation is done trought holding [Shift] and dragging with [Tertiary] button (MouseWheelButton)
  /// Zoom is done trought scrolling with [MouseWheel]
  /// required [child] The child widget
  /// TODO: test and implement handlers for touch gestures, currently only mouse and keyboard is tested
  factory WorkspaceControls.orbit({
    required Widget child,
    ControlGestureCallback? onPan,
    ControlGestureCallback? onRotate,
    ControlGestureCallback? onZoom,
  }) {
    return WorkspaceControls(
      pan: ControlGesture(
          button: kTertiaryButton,
          key: null,
          callback: (Offset offset) {
            if (onPan == null) {
              print("pan, " + offset.toString());
            } else {
              onPan(offset);
            }
          }),
      rotate: ControlGesture(
          button: kTertiaryButton,
          // key: LogicalKeyboardKey.shiftLeft,
          keySet: ControlKeyboardListener.shiftKeys,
          callback: (Offset offset) {
            if (onRotate == null) {
              print("rotate, " + offset.toString());
            } else {
              onRotate(offset);
            }
          }),
      zoom: ControlGesture(
          button: kMouseWheel,
          key: null,
          callback: (Offset offset) {
            if (onZoom == null) {
              print("zoom, " + offset.toString());
            } else {
              onZoom(offset);
            }
          }),
      child: child,
    );
  }

  /// The child widget
  final Widget child;

  ControlState _state = ControlState.none;

  /// Pan gesture
  final ControlGesture pan;

  /// Rotate gesture
  final ControlGesture rotate;

  /// Zoom gesture
  final ControlGesture zoom;

  /// current key state for the [pan] gesture key
  /// if no key is present [KeyPressState] stays [undefined]
  KeyPressState _panKeyState = KeyPressState.undefined;

  /// current key state for the [rotate] gesture key
  KeyPressState _rotateKeyState = KeyPressState.undefined;

  /// current key state for the [zoom] gesture key
  KeyPressState _zoomKeyState = KeyPressState.undefined;

  /// internal map of callbacks for [ControlKeyboardListener]
  Map<LogicalKeyboardKey, KeyboardKeyCallback>? _keyboardCallbacks;

  /// builds the callback list for [ControlKeyboardListener]
  Map<LogicalKeyboardKey, KeyboardKeyCallback> _buildKeyboardCallbackList() {
    Map<LogicalKeyboardKey, KeyboardKeyCallback> data = {};
    // assert(pan.key == null && pan.keySet == null, "pan key and keyset can't both be null");
    // assert(rotate.key == null && rotate.keySet == null, "rotate key and keyset can't both be null");
    // assert(zoom.key == null && zoom.keySet == null, "zoom key and keyset can't both be null");

    // assert(pan.key == null && pan.keySet == null, "pan key and keyset can't both be set");
    // assert(rotate.key == null && rotate.keySet == null, "rotate key and keyset can't both be set");
    // assert(zoom.key == null && zoom.keySet == null, "zoom key and keyset can't both be set");

    if (pan.key != null) {
      data[pan.key!] = (down, event) {
        _panKeyState = down ? KeyPressState.down : KeyPressState.up;
      };
    } else {
      for (var key in pan.keySet) {
        data[key] = (down, event) {
          _panKeyState = down ? KeyPressState.down : KeyPressState.up;
        };
      }
    }

    if (rotate.key != null) {
      data[rotate.key!] = (down, event) {
        _rotateKeyState = down ? KeyPressState.down : KeyPressState.up;
      };
    } else {
      for (var key in rotate.keySet) {
        data[key] = (down, event) {
          _rotateKeyState = down ? KeyPressState.down : KeyPressState.up;
        };
      }
    }

    if (zoom.key != null) {
      data[zoom.key!] = (down, event) {
        _zoomKeyState = down ? KeyPressState.down : KeyPressState.up;
      };
    } else {
      for (var key in zoom.keySet) {
        data[key] = (down, event) {
          _zoomKeyState = down ? KeyPressState.down : KeyPressState.up;
        };
      }
    }

    _keyboardCallbacks = data;

    return data;
  }

  bool isAnyKeyDown(String exclude) {
    bool panDown = false;
    bool dollyDown = false;
    bool zoomDown = false;
    if (exclude != "pan") {
      panDown = _panKeyState != KeyPressState.up ? true : false;
    }
    if (exclude != "rotate") {
      dollyDown = _rotateKeyState != KeyPressState.up ? true : false;
    }
    if (exclude != "zoom") {
      zoomDown = _zoomKeyState != KeyPressState.up ? true : false;
    }

    return (panDown || dollyDown || zoomDown) ? true : false;
  }

  bool isGestureButtonDown(String gesture, var event) {
    bool down = false;
    if (gesture == "pan") {
      down =
          (pan.button == event.buttons || pan.keySet.contains(event.buttons)) &&
                  _panKeyState != KeyPressState.up
              ? true
              : false;
      // down = _panKeyState != KeyPressState.up;
      // down = (pan.button == event.buttons || pan.keySet.contains(event.buttons)) && _panKeyState != KeyPressState.up ? true : false;
    }
    if (gesture == "rotate") {
      // down = rotate.button == event.buttons || rotate.keySet.contains(event.buttons) && _rotateKeyState != KeyPressState.up;
      down = (rotate.button == event.buttons ||
                  rotate.keySet.contains(event.buttons)) &&
              _rotateKeyState != KeyPressState.up
          ? true
          : false;
    }
    if (gesture == "zoom") {
      // down = zoom.button == event.buttons || zoom.keySet.contains(event.buttons) && _zoomKeyState != KeyPressState.up;
      down = (zoom.button == event.buttons ||
                  zoom.keySet.contains(event.buttons)) &&
              _zoomKeyState != KeyPressState.up
          ? true
          : false;
    }

    // if(down) {
    //   print("isGestureButtonDown($gesture): $down");
    // }

    return down;
  }
  
  Set<LogicalKeyboardKey> _currentKeys = {};

  @override
  Widget build(BuildContext context) {
    return ControlKeyboardListener(
      autofocus: true,
      onKeyCallbacks: _keyboardCallbacks ?? _buildKeyboardCallbackList(),
      child: Listener(
        onPointerDown: (event) {
          // print("down");
          _currentKeys.add(event.log)
        },
        onPointerUp: (event) {
          // print("up");
        },
        onPointerMove: (event) {
          // only gets called when a button is pressed while moving

          ControlState newState = ControlState.none;

          // if (isGestureButtonDown("pan", event) && !isAnyKeyDown("pan")) {
          if (isGestureButtonDown("pan", event) && !isAnyKeyDown("pan")) {
            // pan
            // pan.callback(event.delta);

            print("pan start");

            newState = ControlState.pan;
          }
          if (isGestureButtonDown("rotate", event) && !isAnyKeyDown("rotate")) {
            // rotate
            // rotate.callback(event.delta);
            print("dolly start");
            newState = ControlState.dolly;
          }
          if (isGestureButtonDown("zoom", event) && !isAnyKeyDown("zoom")) {
            // zoom
            // zoom.callback(event.delta);
            print("zoom start");
            newState = ControlState.zoom;
          }

          switch (newState) {
            case ControlState.pan:
              print("pan");
              pan.callback(event.delta);
              break;
            case ControlState.dolly:
              print("dolly");
              rotate.callback(event.delta);
              break;
            case ControlState.zoom:
              print("zoom");
              zoom.callback(event.delta);
              break;
            case ControlState.none:
              break;
          }

          _state = newState;

          // if (pan != null && event.buttons == pan!.pointer) {}

          // if (event.buttons == kPrimaryButton) {
          //   print("primary move");
          // } else if (event.buttons == kSecondaryButton) {
          //   print("secondary move");
          // } else if (event.buttons == kTertiaryButton) {
          //   print("tertiary move");
          // }
        },
        onPointerHover: (event) {
          // gets called also when no button is pressed.
          // print("hover");
        },
        onPointerCancel: (event) {
          // print("cancel");
        },
        onPointerSignal: (PointerSignalEvent event) {
          if (zoom.button == kMouseWheel && _zoomKeyState != KeyPressState.up) {
            if (event is PointerScrollEvent) {
              // PointerScrollEvent e = event as PointerScrollEvent;
              zoom.callback(Offset(0, event.scrollDelta.dy));
            }
          }
          // if (event is PointerScrollEvent) {
          //   // print('x: ${event.position.dx}, y: ${event.position.dy}');
          //   // print('scroll delta: ${event.scrollDelta}');
          //   PointerScrollEvent e = event as PointerScrollEvent;
          //   _zoom(event.scrollDelta.dy);
          //   // Offset
          // }
          // if(tertiaryButtonDown) {
          //   print(event);
          // }
          // // if(event is PointerDownEvent) {
          // //   PointerDownEvent e = event as PointerDownEvent;
          // //   print(e);
          // // }
        },
        child: child,
      ),
    );
  }
}
