// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:visited_places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  /** Test LocationImage Getter */
  String get locationImage {
    if (_pickedLocation == null) return '';

    final lat = _pickedLocation!.latitude.toStringAsFixed(6);
    final lng = _pickedLocation!.longitude.toStringAsFixed(6);

    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$lat,$lng'
        '&zoom=13'
        '&size=600x300'
        '&maptype=roadmap'
        '&markers=color:red%7C$lat,$lng'
        '&key=AIzaSyC_lPBJWs1E5WEFAypAjm8ChB6lko4DEVI';
  }

  // String get locationImage {
  //   if (_pickedLocation == null) {
  //     return '';
  //   }
  //   final lat = _pickedLocation!.latitude;
  //   final lng = _pickedLocation!.longitude;
  //   return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=AIzaSyC_lPBJWs1E5WEFAypAjm8ChB6lko4DEVI';
  // }

  // void _getCurrentLocation() async {
  //   print("START _getCurrentLocation()");

  //   setState(() => _isGettingLocation = true);

  //   Location location = Location();

  //   bool serviceEnabled = await location.serviceEnabled();
  //   print("serviceEnabled = $serviceEnabled");

  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     print("requestService result = $serviceEnabled");
  //     if (!serviceEnabled) return;
  //   }

  //   PermissionStatus permissionGranted = await location.hasPermission();
  //   print("hasPermission = $permissionGranted");

  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     print("requestPermission = $permissionGranted");
  //     if (permissionGranted != PermissionStatus.granted) return;
  //   }

  //   print("Fetching GPS...");
  //   final locationData = await location.getLocation();
  //   print("GPS lat=${locationData.latitude}, lng=${locationData.longitude}");

  //   final lat = locationData.latitude;
  //   final lng = locationData.longitude;

  //   if (lat == null || lng == null) {
  //     print("lat/lng null");
  //     setState(() => _isGettingLocation = false);
  //     return;
  //   }

  //   print("Calling Geocoding API...");
  //   final url = Uri.parse(
  //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=YOUR_KEY',
  //   );

  //   final response = await http.get(url);
  //   print("HTTP STATUS: ${response.statusCode}");
  //   print("BODY: ${response.body}");

  //   final resData = json.decode(response.body);

  //   if (resData['results'] == null || resData['results'].isEmpty) {
  //     print("No geocoding results");
  //     setState(() => _isGettingLocation = false);
  //     return;
  //   }

  //   final address = resData['results'][0]['formatted_address'];
  //   print("ADDRESS FOUND: $address");

  //   setState(() {
  //     _pickedLocation = PlaceLocation(
  //       latitude: lat,
  //       longitude: lng,
  //       address: address,
  //     );
  //     _isGettingLocation = false;
  //   });

  //   print("DONE — _pickedLocation is set!");
  // }

  /** Second function (not from me) */

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() => _isGettingLocation = false);
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() => _isGettingLocation = false);
        return;
      }
    }

    final locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      setState(() => _isGettingLocation = false);
      return;
    }

    // --- Geocoding API ---
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyC_lPBJWs1E5WEFAypAjm8ChB6lko4DEVI',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['status'] != 'OK') {
      print("Geocoding failed: ${data['status']} - ${data['error_message']}");
      setState(() => _isGettingLocation = false);
      return;
    }

    final address = data['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  // void _getCurrentLocation() async {
  //   setState(() {
  //     _isGettingLocation = true;
  //   });

  //   Location location = Location();

  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //   LocationData locationData;

  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   setState(() {
  //     _isGettingLocation = true;
  //   });

  //   locationData = await location.getLocation();
  //   final lat = locationData.latitude;
  //   final lng = locationData.longitude;

  //   if (lat == null || lng == null) {
  //     setState(() => _isGettingLocation = false);
  //     return;
  //   }

  //   final url = Uri.parse(
  //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyC_lPBJWs1E5WEFAypAjm8ChB6lko4DEVI',
  //   );
  //   final response = await http.get(url);
  //   final resData = json.decode(response.body);
  //   print(response.body);

  //   final address = resData['results'][0]['formatted_address'];

  //   setState(() {
  //     _pickedLocation = PlaceLocation(
  //       latitude: lat,
  //       longitude: lng,
  //       address: address,
  //     );
  //     _isGettingLocation = false;
  //   });
  //   widget.onSelectLocation(_pickedLocation!);

  //   print(locationData.latitude);
  //   print(locationData.longitude);
  // }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child:
              // Text(
              //   'No location chosen',
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //     color: Theme.of(context).colorScheme.onBackground,
              //   ),
              // ),
              previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
              onPressed: _getCurrentLocation,
            ),
            // TextButton.icon(
            //   icon: const Icon(Icons.map),
            //   label: const Text('Select on map'),
            //   onPressed: () {},
            // ),
          ],
        ),
      ],
    );
  }
}
