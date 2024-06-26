import 'package:flutter/material.dart';
import 'package:learn_pt/core/routes/app_routes.dart';
import 'package:learn_pt/presentation/screens/dashbaord_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // Object? argument = settings.arguments;
  switch (settings.name) {
    case AppRoutes.dashboardScreen:
      return MaterialPageRoute(builder: (context) => const DashboardScreen());
    default:
      return MaterialPageRoute(builder: (context) => const DashboardScreen());
  }
}
