import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/orentation.dart';
import '../utils/orentation_utils.dart';

class OptionButton extends StatefulWidget {
  final IconData icon;
  final Function onTapCallback;
  final bool isEnabled;
  const OptionButton({
    Key? key,
    required this.icon,
    required this.onTapCallback,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.3,
        child: ClipOval(
          child: Material(
            color: const Color(0x0000000F),
            child: InkWell(
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              onTap: () {
                HapticFeedback.selectionClick();

                widget.onTapCallback();
              },
            ),
          ),
        ),
      ),
    );
  }
}
