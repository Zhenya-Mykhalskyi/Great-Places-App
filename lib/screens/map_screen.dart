import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  const MapScreen(
      {Key key,
      this.initialLocation =
          const PlaceLocation(latitude: 49.5551614, longitude: 25.5989988),
      this.isSelecting = false})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedLocation == null //якщо маркер не поставлений
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                      //при закритті, вертаються дані _pickedLocation. Вертаються в locationInput, а отже відображаються в AddPlaceScreen
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            // якщо точка не стоїть і якщо ми не в процесі вибору (isSelecting по замовчуванню false і ми ставимо його в true, коли виконується функція вибору точки).
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ?? // ==null
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                  // _pickedLocation ==null тому, що ми його тут не вибираємо
                ),
              },
        // {} - це set(набір), відрізняється від списку тим, що у ньому можуть міститися тільки унікальні значення. Не має ключів, а тільки унікальні значення. Повторні значення не добавляються
      ),
    );
  }
}
