import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_pt/cubit/camera_ready_cubit/camera_ready_state.dart';

class CameraReadyCubit extends Cubit<CameraReadyState> {
  CameraReadyCubit() : super(CameraStartingState());

  void startCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      for (var element in cameras) {
        debugPrint("debugCamera:${element.toString()}");
      }
      CameraController cameraController =
          CameraController(cameras.first, ResolutionPreset.high);
      await cameraController.initialize();
      emit(CameraIsReadyState(cameraController: cameraController));
    } catch (e) {
      emit(CameraErrorState(errorMsg: e.toString()));
    }
  }
}
