import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

part 'event.dart';
part 'state.dart';

class CamerasBloc extends Bloc<CamerasEvent, CamerasState> {
  List<CameraDescription> cameras = [];
  int currentPostion = 0;
  late CameraController controller;

  CamerasBloc() : super(InitingCameras()) {
    on<InitCameras>(_initCameras);
    on<NextCamera>(_nextCamera);
    on<ChangeFlashModeCamera>(_changeMode);
  }
  void _initCameras(InitCameras event, Emitter<CamerasState> emmit) async {
    try {
      cameras = await availableCameras();
    } on CameraException {
      emmit(ErrorInitingCameras());
      return;
    }
    if (cameras.isEmpty) {
      emmit(NotAvailebleCameras());
      return;
    }

    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      emmit(NotPermissions());
      return;
    }
    controller =
        CameraController(cameras[currentPostion], ResolutionPreset.max);
    try {
      await controller.initialize();
    } on CameraException {
      emmit(ErrorInitingCameras());
      return;
    }
    setMode(FlashMode.auto);

    emmitCurrentStatus(emmit);
  }

  void _nextCamera(NextCamera event, Emitter<CamerasState> emmit) async {
    if (cameras.isEmpty) {
      return;
    }
    if (cameras.length == 1) {
      return;
    }
    if (currentPostion == 1) {
      currentPostion = 0;
    } else {
      currentPostion = 1;
    }

    controller = CameraController(cameras[currentPostion], ResolutionPreset.max,
        enableAudio: false);
    try {
      await controller.initialize();
    } on CameraException {
      emmit(ErrorInitingCameras());
      return;
    }
    emmitCurrentStatus(emmit);
  }

  void emmitCurrentStatus(Emitter<CamerasState> emmit) {
    emmit(ReadyCameras(
      controller: controller,
      countCameras: cameras.length,
    ));
  }

  Future<void> setMode(FlashMode m) async {
    try {
      await controller.setFlashMode(m);
    } on CameraException {
      return;
    }
  }

  void _changeMode(
      ChangeFlashModeCamera event, Emitter<CamerasState> emmit) async {
    FlashMode newMode = FlashMode.off;

    switch (controller.value.flashMode) {
      case FlashMode.off:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.torch;
        break;
      default:
        newMode = FlashMode.off;
        break;
    }
    await setMode(newMode);

    emmitCurrentStatus(emmit);
  }
}
