import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/provider/detail_story_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailMapPage extends StatefulWidget {
  const DetailMapPage({Key? key}) : super(key: key);

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final detailStoryProvider = Provider.of<DetailStoryProvider>(context);
    final latitude = detailStoryProvider.latitude;
    final longitude = detailStoryProvider.longitude;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)!.mapStory} ${detailStoryProvider.detailStory!.story.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            ),
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: {
              Marker(
                markerId: const MarkerId('location_marker'),
                position: LatLng(latitude, longitude),
              ),
            },
          ),
          Positioned(
            bottom: 180,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom-in",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.small(
                  heroTag: "zoom-out",
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: FutureBuilder<List<geo.Placemark>>(
              future: geo.placemarkFromCoordinates(latitude, longitude),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final placemarks = snapshot.data!;
                  if (placemarks.isNotEmpty) {
                    final firstPlacemark = placemarks.first;
                    return PlacemarkWidget(
                      placemark: firstPlacemark,
                      latitude: latitude,
                      longitude: longitude,
                    );
                  } else {
                    return const Text('No placemarks found');
                  }
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({
    super.key,
    required this.placemark,
    required this.latitude,
    required this.longitude,
  });

  /// create a variable
  final geo.Placemark placemark;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      /// show the information
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: AppColor.secondary.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Latitude: $latitude",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  "Longitude: $longitude",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
