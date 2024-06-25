import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:learn_pt/cubit/image_processing_cubit/camera_serialize.dart';
import 'package:learn_pt/cubit/image_processing_cubit/isolate_data_model.dart';
import 'package:learn_pt/cubit/image_processing_cubit/isolates.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:learn_pt/cubit/image_processing_cubit/image_processing_state.dart';

class ImageProcessingCubit extends Cubit<ImageProcessingState> {
  ImageProcessingCubit() : super(NotStartedState()) {
    initializeModel();
  }

  ModelObjectDetection? objectModel;
  DateTime lastDetectionPerformed = DateTime.now();
  bool _isProcessing = false;
  int detectionThrottlingPeriodInMilliseconds = 300;

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
            Duration(milliseconds: detectionThrottlingPeriodInMilliseconds)) {
          lastDetectionPerformed = DateTime.now();
          _isProcessing = true;

          try {
            // Ensure RootIsolateToken is initialized after Flutter bindings
            // RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
            // if (rootIsolateToken != null) {
            DateTime beforeP = DateTime.now();

            List<ResultObjectDetection>? prediction =
                await objectModel?.getCameraImagePrediction(cameraImage, 90,
                    minimumScore: 0.2, iOUThreshold: 0.2);
            //     await Isolate.run<List<ResultObjectDetection>?>(() async {
            //   return await objectModel?.getCameraImagePrediction(
            //       cameraImage, 90,
            //       minimumScore: 0.2, iOUThreshold: 0.2);
            // });
            // await objectModel?.getCameraImagePredictionList(cameraImage, 90,
            //     iOUThreshold: 0.2, minimumScore: 0.2);
            //     await flutterCompute(
            //   runPredictionInDiffIsolate,
            //   IsolateData(
            //     cameraImageData: serializeCameraImage(cameraImage),
            //     imageHeight: 90,
            //     minimumScore: 0.2,
            //     iOUThreshold: 0.2,
            //     token: rootIsolateToken,
            //   ).toMap(),
            // );

            DateTime afterP = DateTime.now();
            print(
                "debugCheckRespTime: time diff between afterP and beforeP: ${afterP.difference(beforeP).inMilliseconds}");

            debugPrint("debugPredictionData: $prediction");

            emit(PredictionReadyState(predictionData: prediction));
            // } else {
            //   debugPrint("RootIsolateToken is null");
            // }
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
      print("Image stream stopped successfully");
    } catch (e) {
      print("Error stopping image stream: $e");
    }
  }
}
