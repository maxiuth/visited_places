import 'package:flutter/material.dart';

import 'package:visited_places/widgets/places_list.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext contect) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: PlacesList(places: []),
    );
  }
}
