import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _controller;

  // Set initial position for the map
  final LatLng _initialPosition = const LatLng(37.77483, -122.41942); // San Francisco

  // Set markers
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('initialMarker'),
        position: _initialPosition,
        infoWindow: const InfoWindow(
          title: 'San Francisco',
          snippet: 'An interesting city',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        mapType: MapType.normal,
        myLocationEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }
}
