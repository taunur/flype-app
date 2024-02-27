import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flype/data/api/add_story_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/model/upload_response.dart';
import 'package:image/image.dart' as img;

class UploadProvider extends ChangeNotifier {
  final AddStoryService addStoryService;
  final AuthRepository authRepository;
  UploadProvider(this.addStoryService, this.authRepository);

  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      final String token = await authRepository.getToken() ?? '';
      uploadResponse = await addStoryService.uploadDocument(
          bytes, fileName, description, token);
      message = uploadResponse?.message ?? "success";
    } catch (e) {
      message = e.toString();
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
