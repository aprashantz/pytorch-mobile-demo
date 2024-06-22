import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:learn_pt/cubit/image_processing_cubit/image_processing_state.dart';

class ImageProcessingCubit extends Cubit<ImageProcessingState> {
  ImageProcessingCubit() : super(NotStartedState()) {
    initializeModel();
  }

  ModelObjectDetection? objectModel;
  DateTime lastDetectionPerformed = DateTime.now();
  bool _isProcessing = false;
  int detectionThrottlingPeriodInMiliseconds = 300;

  void initializeModel() async {
    try {
      objectModel = await PytorchLite.loadObjectDetectionModel(
        "assets/yolov5s.torchscript",
        80,
        640,
        640,
        labelPath: "assets/labels_objectDetection_Coco.txt",
      );
    } catch (e) {
      emit(ErrorPredictingState(errorMsg: "Error loading model: $e"));
    }
  }

  void startPredicting(CameraController cameraController) async {
    try {
      await cameraController.startImageStream((CameraImage cameraImage) async {
        if (_isProcessing) return;

        if (DateTime.now().difference(lastDetectionPerformed) >
            Duration(milliseconds: detectionThrottlingPeriodInMiliseconds)) {
          lastDetectionPerformed = DateTime.now();
          _isProcessing = true;

          try {
            if (objectModel != null) {
              List<ResultObjectDetection>? prediction =
                  await objectModel?.getCameraImagePrediction(cameraImage, 90,
                      minimumScore: 0.2, iOUThreshold: 0.2);

              debugPrint("debugPredictionData: $prediction");

              emit(PredictionReadyState(predictionData: prediction));
            } else {
              debugPrint("Object model is not loaded");
            }
          } catch (e) {
            debugPrint("Error during prediction: $e");
            emit(ErrorPredictingState(errorMsg: e.toString()));
          } finally {
            _isProcessing = false;
          }
        }
      });
    } catch (e) {
      debugPrint("Error starting image stream: $e");
      emit(ErrorPredictingState(errorMsg: "Error starting image stream: $e"));
    }
  }

  void stopPredicting(CameraController cameraController) {
    try {
      cameraController.stopImageStream();
      debugPrint("Image stream stopped successfully");
    } catch (e) {
      debugPrint("Error stopping image stream: $e");
    }
  }
}
