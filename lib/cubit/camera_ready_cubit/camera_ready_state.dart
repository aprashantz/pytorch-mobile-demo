import 'package:camera/camera.dart';

abstract class CameraReadyState {}

class CameraStartingState extends CameraReadyState {}

class CameraIsReadyState extends CameraReadyState {
  final CameraController cameraController;

  CameraIsReadyState({required this.cameraController});
}

class CameraErrorState extends CameraReadyState {
  final String errorMsg;

  CameraErrorState({required this.errorMsg});
}
