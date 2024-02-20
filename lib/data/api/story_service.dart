import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class StoryServices {
  Future<List<ListStory>> getAllStory() async {
    final response = await http.get(Uri.parse(AppConstants.getStory));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['listStory'];
      debugPrint("$response");
      return data.map((json) => ListStory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load AllStory');
    }
  }
}
