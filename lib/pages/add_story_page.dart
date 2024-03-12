import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/export.dart';
import 'package:flype/config/flavor_config.dart';
import 'package:flype/data/provider/add_story_provider.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/provider/upload_provider.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:flype/widgets/button_custom.dart';
import 'package:flype/widgets/loading_button.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({
    super.key,
  });

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController descriptionController =
      TextEditingController(text: '');

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocationProvider = Provider.of<AddStoryProvider>(context);
    final selectedLocation = selectedLocationProvider.selectedLocation;

    /// Flavor
    FlavorType flavor = FlavorConfig.instance.flavor;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addStory),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _onClear(),
            icon: const Icon(Icons.delete),
            tooltip: "Clear",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: context.watch<AddStoryProvider>().imagePath == null
                  ? const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 100,
                      ),
                    )
                  : _showImage(),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onGalleryView(),
                    child: Text(AppLocalizations.of(context)!.gallery),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCameraView(),
                    child: Text(AppLocalizations.of(context)!.camera),
                  ),
                ],
              ),
            ),
            if (flavor == FlavorType.free)
              ElevatedButton(
                onPressed: () {
                  // Show payment popup
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Upgrade to Premium"),
                        content: const Text(
                            "To access add location, please upgrade to premium."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Upgrade"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Unlock Feature"),
              )
            else if (flavor == FlavorType.paid)
              selectedLocation != null
                  ? ElevatedButton(
                      onPressed: () => context.go('/navBar/addStory/maps'),
                      child: Text('$selectedLocation'),
                    )
                  : ElevatedButton(
                      onPressed: () => context.go('/navBar/addStory/maps'),
                      child: Text(AppLocalizations.of(context)!.addLocation),
                    )
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Show payment popup
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Upgrade to Premium"),
                            content: const Text(
                                "To access add location, please upgrade to premium."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Upgrade"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Unlock Feature"),
                  ),
                  selectedLocation != null
                      ? ElevatedButton(
                          onPressed: () => context.go('/navBar/addStory/maps'),
                          child: Text('$selectedLocation'),
                        )
                      : ElevatedButton(
                          onPressed: () => context.go('/navBar/addStory/maps'),
                          child:
                              Text(AppLocalizations.of(context)!.addLocation),
                        ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  TextFormField(
                    minLines: null,
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.description,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColor.darkerBlack,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColor.blue,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  context.watch<UploadProvider>().isUploading
                      ? const LoadingButton()
                      : FillButtonCustom(
                          label: AppLocalizations.of(context)!.upload,
                          onTap: () => _onUpload(),
                          isExpanded: true,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();
    final addStoryProvider = context.read<AddStoryProvider>();
    final latLng = context.read<AddStoryProvider>().selectedLocation;

    final imagePath = addStoryProvider.imagePath;
    final imageFile = addStoryProvider.imageFile;

    if (imagePath == null || imageFile == null) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please upload a photo first")),
      );
      return;
    }

    final description = descriptionController.text.trim();
    if (description.isEmpty) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please input description")),
      );
      return;
    }

    double? lat;
    double? lon;

    if (latLng != null) {
      lat = latLng.latitude;
      lon = latLng.longitude;
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(newBytes, fileName, description, lat, lon);

    if (uploadProvider.uploadResponse != null) {
      addStoryProvider.setImageFile(null);
      addStoryProvider.setImagePath(null);
      addStoryProvider.selectedLocation = null;
      descriptionController.clear();
      goRouter.replace('/navBar');
      setState(() {
        context.read<StoryProvider>().refresh();
      });
    }
    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  void _onClear() {
    final provider = context.read<AddStoryProvider>();
    provider.setImageFile(null);
    provider.setImagePath(null);
    provider.selectedLocation = null;
    descriptionController.clear();
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
