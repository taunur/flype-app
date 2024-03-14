import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flype/data/api/connection_services.dart';

class AddStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  LatLng? selectedLocation;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setSelectedLocation(double? latitude, double? longitude) {
    if (latitude != null && longitude != null) {
      selectedLocation = LatLng(latitude, longitude);
      notifyListeners();
    }
  }

  Future<bool> checkInternetConnection() async {
    return await ConnectionServices().isInternetAvailable();
  }
}
