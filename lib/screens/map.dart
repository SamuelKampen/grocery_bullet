import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:provider/provider.dart';

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
        stream: Firestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          Location currentLocation =
              Provider.of<CurrentLocation>(context).getCurrentLocation();
          if (currentLocation != null && snapshot.hasData) {
            Map<GeoPoint, Marker> markers = {};
            for (DocumentSnapshot documentSnapshot in snapshot.data.documents) {
              Location location = Location.fromSnapshot(documentSnapshot);
              Marker marker = Marker(
                markerId: MarkerId(location.name),
                position: LatLng(
                    location.geoPoint.latitude, location.geoPoint.longitude),
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
          }
          return Container();
        });
  }
}
