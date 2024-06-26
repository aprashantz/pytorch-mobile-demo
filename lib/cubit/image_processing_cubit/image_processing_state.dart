abstract class ImageProcessingState {}

class NotStartedState extends ImageProcessingState {}

class PredictionReadyState extends ImageProcessingState {
  // List<ResultObjectDetection>? predictionData;
  String? predictionData;

  PredictionReadyState({required this.predictionData});
}

class ErrorPredictingState extends ImageProcessingState {
  final String errorMsg;

  ErrorPredictingState({required this.errorMsg});
}
