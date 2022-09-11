import 'package:flutter/material.dart';
import 'package:photoreport_mobile/plugins/camera/models/capture_modes.dart';

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
