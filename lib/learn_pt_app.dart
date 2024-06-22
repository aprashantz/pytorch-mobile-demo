import 'package:flutter/material.dart';
import 'package:learn_pt/core/routes/route_generator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_pt/cubit/camera_ready_cubit/camera_ready_cubit.dart';
import 'package:learn_pt/cubit/image_processing_cubit/image_processing_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LearnPtApp extends StatelessWidget {
  const LearnPtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CameraReadyCubit()),
        BlocProvider(create: (context) => ImageProcessingCubit()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: true,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
