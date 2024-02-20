import 'package:flutter/material.dart';
import 'package:flype/data/api/story_service.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/utils/result_state.dart';

class StoryProvider extends ChangeNotifier {
  final StoryServices storyServices;

  ResultState _state = ResultState.noData;

  StoryProvider({
    required this.storyServices,
  }) {
    _getStory();
  }

  List<ListStory> _allStories = [];
  List<ListStory> get allStories => _allStories;

  String _message = '';
  String get message => _message;

  ResultState get state => _state;

  Future<void> _getStory() async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      final storyResult = await storyServices.getAllStory();

      if (storyResult.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        _allStories = storyResult;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load restaurant. Check your connection.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _getStory();
  }

  Future<void> getRestaurant() async {
    await _getStory();
  }
}
