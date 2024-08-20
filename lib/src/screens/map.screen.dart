import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapState();
}

class _MapState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  double lat = 0;
  double long = 0;

  @override
  initState() {
    super.initState();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;

    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: const MarkerId("1"),
      position: LatLng(lat, long),
      infoWindow: const InfoWindow(
        title: 'Casa vendedor',
        snippet: 'Aqui es',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ubicación"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
          future: getLocation(),
          builder: (context, snapshot) {
            return GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(23.644584, -102.542230),
                zoom: 5.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
