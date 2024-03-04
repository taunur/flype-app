import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flype/data/model/upload_response.dart';
import 'package:flype/data/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class AddStoryService {
  /// addStory
  Future<UploadResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    String token,
  ) async {
    final uri = Uri.parse(AppConstants.addStory);
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final Map<String, dynamic> responseDataMap = json.decode(responseData);
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseDataMap,
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
