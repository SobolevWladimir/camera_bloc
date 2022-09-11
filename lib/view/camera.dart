import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photoreport_mobile/plugins/camera/view/camera_interface.dart';
import 'package:photoreport_mobile/plugins/camera/view/preview_cart.dart';

class CameraItem extends StatefulWidget {
  final CameraController controller;
  final Function(File file) onTakePhoto;
  const CameraItem(this.controller, {Key? key, required this.onTakePhoto})
      : super(key: key);

  @override
  State<CameraItem> createState() => _CameraItemState();
}

class _CameraItemState extends State<CameraItem> with TickerProviderStateMixin {
  AnimationController? showAnimationController;
  Animation<Offset>? _previewAnimation;
  File? lastPhoto;
  bool isReady = true;
  @override
  void initState() {
    showAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _previewAnimation = Tween<Offset>(
      begin: const Offset(10.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: showAnimationController!,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    showAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _previewAnimation = Tween<Offset>(
      begin: MediaQuery.of(context).orientation == Orientation.landscape
          ? const Offset(-10.0, 0.0)
          : const Offset(-2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: showAnimationController!,
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Visibility(
            visible: true,
            child: Positioned(
              top: 0,
              left: 0,
              right: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 100
                  : 0,
              bottom:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0
                      : 80,
              child: Center(
                child: CameraPreview(widget.controller),
              ),
            ),
          ),
          Visibility(visible: !isReady, child: Container(color: Colors.black)),
          //const CameraButton(),
          CameraInterface(
              key: widget.key,
              onTakePhoto: () async {
                setState(() {
                  isReady = false;
                });
                try {
                  XFile image = await widget.controller.takePicture();
                  lastPhoto = File(image.path);
                  widget.onTakePhoto(lastPhoto!);
                } on CameraException {
                  lastPhoto = null;
                }
                setState(() {
                  isReady = true;
                });
                if (showAnimationController!.isCompleted) {
                  showAnimationController!.reset();
                }
                showAnimationController!.forward();
              }),
          PreviewCardWidget(
              previewAnimation: _previewAnimation!, image: lastPhoto),
        ],
      ),
    );
  }
}
