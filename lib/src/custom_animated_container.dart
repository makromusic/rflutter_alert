import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:rflutter_alert/src/measure_size.dart';

// ignore: must_be_immutable
class CustomAnimatedContainer extends StatefulWidget {
  CustomAnimatedContainer(
      {Key key,
      this.width,
      this.height,
      this.child,
      this.onTap,
      this.onDoubleTap,
      this.isDelay = true,
      this.scale = 0.96,
      this.onLongPress})
      : super(key: key);
  final double width, height;
  final Widget child;
  final Function onTap, onDoubleTap, onLongPress;
  bool isDelay;
  double scale = 0.96;
  @override
  _CustomAnimatedContainerState createState() =>
      _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  bool isScale = false;
  var measureSize = Size.zero;
  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        measureSize = size;
      },
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: AnimatedContainer(
          alignment: FractionalOffset.center,
          duration: Duration(milliseconds: 100),
          width: widget.width,
          height: widget.height,
          transform: Matrix4Transform()
              .scale(
                isScale ? widget.scale : 1,
                origin: Offset(
                    // widget.width != null
                    //     ? (widget.width / 2)
                    //     :
                    measureSize.width / 2,
                    // widget.height != null
                    //     ? (widget.height / 2)
                    //     :
                    measureSize.height / 2),
              )
              .matrix4,
          child: widget.child,
        ),
        onTap: () async {
          if (widget.isDelay) await Future.delayed(Duration(milliseconds: 200));

          setState(() {
            isScale = false;
          });
          if (widget.onTap != null) widget.onTap();
        },
        onDoubleTap: widget.onDoubleTap,
        onLongPress: widget.onLongPress,
        onTapDown: (x) {
          setState(() {
            isScale = true;
          });
        },
        onTapCancel: () async {
          await Future.delayed(const Duration(milliseconds: 110));
          setState(() {
            isScale = false;
          });
        },
      ),
    );
  }
}
