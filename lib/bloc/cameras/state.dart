part of 'bloc.dart';

abstract class CamerasState {}

//  Инициализация
class InitingCameras extends CamerasState {}

// ошибка при работе
class ErrorInitingCameras extends CamerasState {}

// Список камер пуст
class NotAvailebleCameras extends CamerasState {}

class NotPermissions extends CamerasState {}

//Камеры готовы
class ReadyCameras extends CamerasState {
  final CameraController controller;
  final int countCameras;

  ReadyCameras({
    required this.controller,
    required this.countCameras,
  });
}
