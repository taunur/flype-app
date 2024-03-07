import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/provider/add_story_provider.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  /// define a variables
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  MapType selectedMapType = MapType.normal;

  /// a placemark to store a location's address
  geo.Placemark? placemark;
  late double currentLatitude;
  late double currentLongitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addLocation),
        centerTitle: true,
      ),
      body: Center(
        /// add google maps widget
        child: Stack(
          children: [
            GoogleMap(
              mapType: selectedMapType,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: dicodingOffice,
              ),

              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,

              /// show the device location's marker
              myLocationEnabled: true,

              /// setup controller and marker
              /// do reverse geocoding in onMapCreated callback
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    dicodingOffice.latitude, dicodingOffice.longitude);

                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                setState(() {
                  placemark = place;
                  currentLatitude = dicodingOffice.latitude;
                  currentLongitude = dicodingOffice.longitude;
                });

                defineMarker(dicodingOffice, street, address);

                setState(() {
                  mapController = controller;
                });
              },

              /// setup callback onLongPress
              onLongPress: (LatLng latLng) => onLongPressGoogleMap(latLng),
            ),

            /// create a FAB widget
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton.small(
                heroTag: "type-map",
                onPressed: null,
                child: PopupMenuButton<MapType>(
                  onSelected: (MapType item) {
                    setState(() {
                      selectedMapType = item;
                    });
                  },
                  offset: const Offset(0, 54),
                  icon: const Icon(Icons.layers_outlined),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MapType>>[
                    const PopupMenuItem<MapType>(
                      value: MapType.normal,
                      child: Text('Normal'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.satellite,
                      child: Text('Satellite'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.terrain,
                      child: Text('Terrain'),
                    ),
                    const PopupMenuItem<MapType>(
                      value: MapType.hybrid,
                      child: Text('Hybrid'),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: "my-location",
                child: const Icon(Icons.my_location),
                onPressed: () => onMyLocationButtonPress(),
              ),
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

            /// show the widget
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  placemark: placemark!,
                  latitude: currentLatitude,
                  longitude: currentLongitude,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// do reverse geocoding in onLongPressGoogleMap function
  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      currentLatitude = latLng.latitude;
      currentLongitude = latLng.longitude;
    });

    /// set a marker based on new lat-long
    defineMarker(latLng, street, address);

    /// animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );

    debugPrint(
        "long press - Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
  }

  void onMyLocationButtonPress() async {
    /// define a location variable
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    /// check the location service
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        debugPrint("Location services is not available");
        return;
      }
    }

    /// check the location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission is denied");
        return;
      }
    }

    /// get the current device location
    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    /// run the reverse geocoding
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    /// define a name and address of location
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      currentLatitude = latLng.latitude;
      currentLongitude = latLng.longitude;
    });

    /// set a marker
    /// show the information of location's place and add new argument
    defineMarker(latLng, street, address);

    /// animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
    debugPrint(
        "my location - Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
  }

  /// define a marker based on a new latLng
  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    /// clear and add a new marker
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}

/// create a location's place widget
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    ElevatedButton(
                      onPressed: () {
                        _onSelectLocation(context, latitude, longitude);

                        goRouter.go('/navBar/addStory');
                      },
                      child: const Text("Select"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectLocation(BuildContext context, double lat, double long) {
    final addStoryProvider =
        Provider.of<AddStoryProvider>(context, listen: false);
    addStoryProvider.setSelectedLocation(lat, long);
  }
}
