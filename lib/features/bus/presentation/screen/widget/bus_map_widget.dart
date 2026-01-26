import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusMapWidget extends StatefulWidget {
  final double busLat;
  final double busLng;
  final String busId;
  final String? busName;

  const BusMapWidget({
    super.key,
    required this.busLat,
    required this.busLng,
    required this.busId,
    this.busName,
  });

  @override
  State<BusMapWidget> createState() => _BusMapWidgetState();
}

class _BusMapWidgetState extends State<BusMapWidget> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late CameraPosition _initialPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(target: LatLng(widget.busLat, widget.busLng), zoom: 14.4746);
    _updateMarkers();
  }

  @override
  void didUpdateWidget(covariant BusMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busLat != widget.busLat || oldWidget.busLng != widget.busLng) {
      print('BusMapWidget: Moving to ${widget.busLat}, ${widget.busLng}'); // Debug log
      _animateToNewLocation();
      _updateMarkers();
    }
  }

  Future<void> _animateToNewLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(widget.busLat, widget.busLng), zoom: 15.0),
      ),
    );
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(widget.busId),
          position: LatLng(widget.busLat, widget.busLng),
          infoWindow: InfoWindow(title: widget.busName ?? 'Bus'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
