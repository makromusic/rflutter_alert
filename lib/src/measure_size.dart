import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback(getSize);
    return Container(
      child: widget.child,
    );
  }

  void getSize(_) {
    if (mounted) {
      final Size newSize = context.size!;

      if (oldSize == newSize) return;

      oldSize = newSize;
      widget.onChange(newSize);
    }
  }
}

typedef OnWidgetSizeChange = void Function(Size size);
