import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:provider/provider.dart';

class CurrentLocationBuilder extends StatefulWidget {
  final AsyncWidgetBuilder asyncWidgetBuilder;

  CurrentLocationBuilder({@required this.asyncWidgetBuilder});

  @override
  _CurrentLocationBuilderState createState() => _CurrentLocationBuilderState(
        asyncWidgetBuilder: asyncWidgetBuilder,
      );
}

class _CurrentLocationBuilderState extends State<CurrentLocationBuilder> {
  CurrentLocation _currentLocation;
  Future<Location> _location;
  final AsyncWidgetBuilder asyncWidgetBuilder;

  _CurrentLocationBuilderState({@required this.asyncWidgetBuilder});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocation = Provider.of<CurrentLocation>(context);
    _location = _currentLocation.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _location,
      builder: asyncWidgetBuilder,
    );
  }
}
