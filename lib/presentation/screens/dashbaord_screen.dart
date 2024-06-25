import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_pt/cubit/camera_ready_cubit/camera_ready_cubit.dart';
import 'package:learn_pt/cubit/camera_ready_cubit/camera_ready_state.dart';
import 'package:learn_pt/cubit/image_processing_cubit/image_processing_cubit.dart';
import 'package:learn_pt/cubit/image_processing_cubit/image_processing_state.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    BlocProvider.of<CameraReadyCubit>(context).startCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CameraReadyCubit, CameraReadyState>(
          listener: (context, state) {
            if (state is CameraIsReadyState) {
              BlocProvider.of<ImageProcessingCubit>(context)
                  .startPredicting(state.cameraController);
            }
          },
          builder: (context, state) {
            if (state is CameraStartingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CameraErrorState) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else if (state is CameraIsReadyState) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CameraPreview(state.cameraController),
                  BlocBuilder<ImageProcessingCubit, ImageProcessingState>(
                    builder: (context, state) {
                      if (state is PredictionReadyState) {
                        return (state.predictionData != null &&
                                (state.predictionData ?? []).isNotEmpty)
                            ? Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    itemCount: state.predictionData?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Center(
                                        child: Row(
                                          children: [
                                            Text(
                                              state.predictionData == null
                                                  ? "null"
                                                  : "Label: ${state.predictionData![index].className ?? ""}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              state.predictionData == null
                                                  ? "null"
                                                  : "Score: ${state.predictionData![index].score.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }
                      return const SizedBox();
                    },
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
