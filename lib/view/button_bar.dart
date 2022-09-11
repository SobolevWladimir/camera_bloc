import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photoreport_mobile/plugins/camera/bloc/cameras/bloc.dart';

import '../models/capture_modes.dart';
import 'button.dart';
import 'camera_button.dart';

class BottomBarWidget extends StatelessWidget {
  final CaptureModes captureMode;
  final bool isRecording;
  final Function onTakePhoto;

  const BottomBarWidget({
    Key? key,
    required this.isRecording,
    required this.captureMode,
    required this.onTakePhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getFlasshButton() {
      IconData icon = Icons.mood_bad;
      final CamerasState state = BlocProvider.of<CamerasBloc>(context).state;

      if (state is ReadyCameras) {
        if (state.controller.description.lensDirection ==
            CameraLensDirection.front) {
          return const SizedBox(width: 48, height: 10);
        }

        switch (state.controller.value.flashMode) {
          case FlashMode.off:
            icon = Icons.flash_off;
            break;
          case FlashMode.auto:
            icon = Icons.flash_auto;
            break;
          case FlashMode.always:
            icon = Icons.flash_on;
            break;
          case FlashMode.torch:
            icon = Icons.flashlight_on;
            break;
        }
      }

      return OptionButton(
        icon: icon,
        onTapCallback: () {
          BlocProvider.of<CamerasBloc>(context).add(ChangeFlashModeCamera());
        },
      );
    }

    Widget getCameraButton() {
      return CameraButton(
        key: const ValueKey('cameraButton'),
        captureMode: captureMode,
        isRecording: isRecording,
        onTap: () {
          onTakePhoto.call();
        },
      );
    }

    Widget getSwithButton() {
      return OptionButton(
        icon: Icons.cameraswitch_outlined,
        onTapCallback: () {
          BlocProvider.of<CamerasBloc>(context).add(NextCamera());
        },
      );
    }

    Widget getPortainInterface() {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Container(
                color: Colors.black12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      getFlasshButton(),
                      getCameraButton(),
                      getSwithButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget getLandscapeInterface() {
      return Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        child: SizedBox(
          width: 100,
          child: Stack(
            children: [
              Container(
                color: Colors.black12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      getSwithButton(),
                      getCameraButton(),
                      getFlasshButton(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return getLandscapeInterface();
    } else {
      return getPortainInterface();
    }
  }
}
