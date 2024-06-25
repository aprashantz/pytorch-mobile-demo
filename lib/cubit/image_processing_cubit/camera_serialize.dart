// import 'dart:typed_data';
// import 'package:camera/camera.dart';

// Map<String, dynamic> serializeCameraImage(CameraImage cameraImage) {
//   return {
//     'planes': cameraImage.planes.map((plane) => plane.bytes).toList(),
//     'height': cameraImage.height,
//     'width': cameraImage.width,
//     'format': cameraImage.format.raw,
//   };
// }

// CameraImage deserializeCameraImage(Map<String, dynamic> map) {
//   return CameraImage.fromPlatformData({
//     'height': map['height'],
//     'width': map['width'],
//     'format': map['format'],
//     'planes': map['planes'].map((bytes) => {'bytes': bytes}).toList(),
//   });
// }
