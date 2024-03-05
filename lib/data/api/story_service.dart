import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flype/data/model/detail_story_model.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class StoryServices {
  /// GetStory
  Future<List<ListStory>> getAllStory({
    required String token,
    int? page,
    int? size,
  }) async {
    final response = await http.get(
      Uri.parse('${AppConstants.getStory}?page=$page&size=$size'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['listStory'];
      debugPrint("$data");
      return data.map((json) => ListStory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load AllStory');
    }
  }

  /// Detail
  Future<DetailStoryModel> getDetailStory({
    required String id,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse(AppConstants.getDetailStory + id),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      debugPrint("detail: $data");
      return DetailStoryModel.fromJson(data);
    } else {
      throw Exception('Failed to load DetailStory');
    }
  }
}
