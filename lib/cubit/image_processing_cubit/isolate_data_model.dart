// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// class IsolateData {
//   final Map<String, dynamic> cameraImageData;
//   final int imageHeight;
//   final double minimumScore;
//   final double iOUThreshold;
//   final RootIsolateToken token;

//   IsolateData({
//     required this.cameraImageData,
//     required this.imageHeight,
//     required this.minimumScore,
//     required this.iOUThreshold,
//     required this.token,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'cameraImageData': cameraImageData,
//       'imageHeight': imageHeight,
//       'minimumScore': minimumScore,
//       'iOUThreshold': iOUThreshold,
//       'token': token,
//     };
//   }

//   factory IsolateData.fromMap(Map<String, dynamic> map) {
//     return IsolateData(
//       cameraImageData: Map<String, dynamic>.from(map['cameraImageData']),
//       imageHeight: map['imageHeight'],
//       minimumScore: map['minimumScore'],
//       iOUThreshold: map['iOUThreshold'],
//       token: map['token'],
//     );
//   }
// }
