import 'package:flutter/material.dart';
import 'package:google_maps_app/view/map_screen/current_location_screen.dart';
import 'package:google_maps_app/view/map_screen/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GoogleMapScreen2(),
    );
  }
}
