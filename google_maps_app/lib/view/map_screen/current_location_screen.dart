import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapScreen2 extends StatefulWidget {
  const GoogleMapScreen2({super.key});

  @override
  State<GoogleMapScreen2> createState() => _GoogleMapScreen2State();
}

class _GoogleMapScreen2State extends State<GoogleMapScreen2> {
  GoogleMapController? _controller;
  LatLng _currentPosition = const LatLng(37.77483, -122.41942); // Initial position: San Francisco
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: const MarkerId('initialMarker'),
        position: _currentPosition,
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
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
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
            onTap: (latLng){
              print("LatLng: $latLng");
            },

          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);

      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocationMarker'),
          position: _currentPosition,
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Blue marker
        ),
      );

      // Move the camera to the current location
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 14.0,
          ),
        ),
      );
    });
  }
}
