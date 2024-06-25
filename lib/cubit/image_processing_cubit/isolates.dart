// import 'package:flutter/services.dart';
// import 'package:pytorch_lite/pytorch_lite.dart';
// import 'package:camera/camera.dart';
// import 'isolate_data_model.dart';
// import 'camera_serialize.dart';

// @pragma('vm:entry-point')
// Future<List<ResultObjectDetection>?> runPredictionInDiffIsolate(
//     Map<String, dynamic> isolateDataMap) async {
//   IsolateData isolateData = IsolateData.fromMap(isolateDataMap);

//   // Initialize the binary messenger for this isolate
//   BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);

//   // Load the model in the isolate
//   ModelObjectDetection objectModel = await PytorchLite.loadObjectDetectionModel(
//     "assets/yolov5s.torchscript",
//     80,
//     640,
//     640,
//     labelPath: "assets/labels_objectDetection_Coco.txt",
//   );

//   CameraImage cameraImage = deserializeCameraImage(isolateData.cameraImageData);

//   return await objectModel.getCameraImagePrediction(
//     cameraImage,
//     isolateData.imageHeight,
//     minimumScore: isolateData.minimumScore,
//     iOUThreshold: isolateData.iOUThreshold,
//   );
// }
