import 'package:camera_bloc/models/capture_modes.dart';
import 'package:flutter/material.dart';

import 'button_bar.dart';

class CameraInterface extends StatelessWidget {
  final Function onTakePhoto;
  const CameraInterface({
    Key? key,
    required this.onTakePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBarWidget(
      onTakePhoto: onTakePhoto,
      isRecording: false,
      captureMode: CaptureModes.PHOTO,
    );
  }
}
