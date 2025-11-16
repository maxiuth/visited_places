// import 'package:flutter/material.dart';

// import 'package:visited_places/widgets/places_list.dart';
// import 'package:visited_places/screens/add_place.dart';

// class PlacesScreen extends StatelessWidget {
//   const PlacesScreen({super.key});

//   @override
//   Widget build(BuildContext contect) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Places'),
//         actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
//       ),
//       body: PlacesList(places: []),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:visited_places/models/place.dart';
import 'package:visited_places/widgets/places_list.dart';
import 'package:visited_places/screens/add_place.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final List<Place> _places = [];

  void _goToAddPlace() async {
    final title = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));

    if (title == null) return;

    setState(() {
      _places.add(Place(title: title));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _goToAddPlace),
        ],
      ),
      body: PlacesList(places: _places),
    );
  }
}
