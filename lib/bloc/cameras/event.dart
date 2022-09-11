part of 'bloc.dart';

abstract class CamerasEvent {}

class InitCameras extends CamerasEvent {}

class NextCamera extends CamerasEvent {}

class ChangeFlashModeCamera extends CamerasEvent {}
