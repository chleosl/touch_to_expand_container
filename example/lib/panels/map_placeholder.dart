import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final double width;
  final double height;

  const MapView({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  double _latitude = 37.5665;
  double _longitude = 126.9780;
  double _zoom = 15.0;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((MapEvent event) {
      if (event is MapEventMove || event is MapEventMoveEnd) {
        setState(() {
          _latitude = event.camera.center.latitude;
          _longitude = event.camera.center.longitude;
          _zoom = event.camera.zoom;
          _rotation = event.camera.rotation;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(_latitude, _longitude),
              initialZoom: _zoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),

          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lat: ${_latitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Lng: ${_longitude.toStringAsFixed(4)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Zoom: ${_zoom.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'Rotation: ${_rotation.toStringAsFixed(1)}°',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
