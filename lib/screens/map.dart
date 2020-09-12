import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/services/StorageService.dart';
import 'package:grocery_bullet/widgets/CurrentLocationBuilder.dart';

class MapPicker extends StatefulWidget {
  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController googleMapController;

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: StorageService.getLocationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.blueGrey,
            );
          }
          return FutureBuilder(
            future: Utils.getLocations(snapshot.data.documents),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: Colors.blueGrey,
                );
              }
              return CurrentLocationBuilder(
                asyncWidgetBuilder: (context, currentLocationSnapshot) {
                  if (!currentLocationSnapshot.hasData) {
                    return Container(
                      color: Colors.blueGrey,
                    );
                  }
                  Location currentLocation = currentLocationSnapshot.data;
                  Map<GeoPoint, Marker> markers = {};
                  List<Location> locations = snapshot.data;
                  for (Location location in locations) {
                    Marker marker = Marker(
                      markerId: MarkerId(location.name),
                      position: LatLng(location.geoPoint.latitude,
                          location.geoPoint.longitude),
                      infoWindow: InfoWindow(
                        title: location.name,
                      ),
                    );
                    markers[location.geoPoint] = marker;
                  }
                  if (googleMapController != null) {
                    googleMapController.moveCamera(
                      CameraUpdate.newLatLng(
                        LatLng(currentLocation.geoPoint.latitude,
                            currentLocation.geoPoint.longitude),
                      ),
                    );
                  }
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation.geoPoint.latitude,
                          currentLocation.geoPoint.longitude),
                      zoom: 15,
                    ),
                    markers: markers.values.toSet(),
                  );
                },
              );
            },
          );
        });
  }
}
